# RMNX by Bernhard 'Elven' Stoeckner
# Licence: Private, for GoldenerWeg. Do not distribute.
# All copyright retained by the author.


require 'socket'

module RMNX
	REPLY_OK  = 0
	REPLY_ERROR = 1
	REPLY_NOTFOUND = 2
	
	# This is a "struct" containing the reply data
	# a command produced.
	class Reply
		attr_reader :code, :data
		def initialize code, data = "", trace = []
			@code = code.to_i
			@data = data
			@trace = trace
		end

		def ok?
			@code == REPLY_OK
		end

		def error?
			@code == REPLY_ERROR
		end

		def to_s
			"#<RMNX::Reply code = '#{@code}', data = '#{@data}'>" #+
				#@trace.size > 0 ? @trace.join(", ") : ""
		end

	end

	module Config
		def savey fn, data
			File.open("db.#{fn}", "w") {|f|
				YAML.dump(data, f)
			}
		end

		def gety fn, default = []
			return (YAML.load(IO.read("db.#{fn}")) || default) if
				File.exists?("db.#{fn}")
			default
		end

		def dely fn
			File.unlink("db.#{fn}")
		end
	end
	
	# This encapsulates a collection of commands that
	# a RMNX::Server answers to.
	class CommandSpace
		attr_reader :name

		attr_reader :rmnx

		def set_rmnx(rmnx)
			@rmnx = rmnx
		end

		def has_command?(c)
			respond_to?("mnx_" + c)
		end

		def call_command(name, args)
			nproc = method("mnx_" + name)
			begin
				ret = nproc.call(*args)
				return ok(ret)
			rescue Exception => ee
				return err(ee.class.to_s + ": " + ee.to_s, ee.backtrace)
			end
		end
		
		private
		# shorthand reply for returning "OK"
		# return OK to indicate the command
		# succeeded, with optional data
		def ok data = ""
			Reply.new(REPLY_OK, data)
		end

		# shorthand for ERROR
		# return if the command failed,
		# with optional error message
		# (and a backtrace)
		def err data = "", trace = []
			Reply.new(REPLY_ERROR, data, trace)
		end
	end

	# This is a server, which handles RMNX::Command
	# requests by remote nwnds
	class Server
		# Increase this if you will send REALLY huge data.
		BUFSIZE = 2 << 15

		attr_reader :startup

		def initialize(host, port) #, peerhost, peerport)
			@host, @port = host, port
			@peerhost, @peerport = nil, nil
			@s = UDPSocket.new
			@c = nil
			@s.bind(host, port)
			@t = Thread.new { _t }
			@rcp = {}
			@commandspace = []
			@startup = Time.now
		end

		def add_command_space(s)
			@commandspace << s
			s.set_rmnx(self)
		end

		
		def has_command?(commandname)
			space = nil
			@commandspace.each do |s|
				return true if s.has_command?(commandname)
			end
		end

		# Calls a command.
		# Returns RMNX::Reply, ready for the wire.
		def call_command(commandname, argv)
			results = []
			@commandspace.each do |s|
				if s.has_command?(commandname)
					s.call_command("_pre", "") if s.has_command?("_pre")
					ret = s.call_command(commandname, argv)
					s.call_command("_post", "") if s.has_command?("_post")
					results << ret 
					#return ret
				end
			end

			errors = results.reject {|o| o.is_a?(RMNX::Reply) && !o.error? }.compact		
			return errors[-1] if errors.size > 0

			results = results.reject {|o| o == nil ||
				(o.is_a?(RMNX::Reply) && !o.ok?)}.compact
			

			results[-1] || Reply.new(REPLY_NOTFOUND, "")
		end

		private
		
		# 1h
		PURGE_DELAY = 60 * 60

		def purge
			n = Time.now
			@rcp.each do |k,v|
				if ((n.to_i - v[2].to_i) > PURGE_DELAY)
					@rcp.delete(k)
				end
			end
		end

		def _t
			loop do
			r = @s.recvfrom(BUFSIZE)
				
				#if r[1][3] != "127.0.0.1"
				#	puts "Notice: Dropping data packet from #{r[1][3]} (not local)"
				#	next
				#end

				if r[1][1] != @peerport
					@peerport, @peerhost = r[1][1], r[1][3]
					puts "Found remote endpoint at #{@peerhost}:#{@peerport}"
					@c = UDPSocket.new
					@c.connect(@peerhost, @peerport)
				end
				
				if r[1][3] != @peerhost
					puts "Notice: Received data packet from unknown source: #{r[1].inspect}"
					next
				end
				d = r[0].gsub(/[\000\.]+$/, "")
				cmd, *param = d.split("!")
				for i in 0...param.size do
					param[i].gsub!("#EXCL#", "!")
				end
				case cmd
					when "RMNXD", "RECEIPT"
						if cmd == "RMNXD"
							puts "Received RMNXD-token:"
							puts " " + param.join("\n ")
							puts "Dropping it."
							next
						end
						rcp = param[0]
						if @rcp[rcp].nil?
							$stderr.puts "WARNING: received unknown receipt-id #{rcp}"
							next
						end
						cmd, param, time = @rcp[rcp]
						if cmd.nil?
							$stderr.puts "WARNING: nil-command"
							next
						end
						reply = delegate cmd, param
						if reply.code == REPLY_ERROR
							$stderr.puts "ERROR: %s" % reply.data
						end
						p reply
						send_reply reply
						@rcp.delete rcp
						next
					when /^[A-Z_]+$/i
						print(([cmd] + param).inspect + ": ")
						a = aquire_receipt
						@rcp[a.to_s] = [cmd.downcase, param, Time.new.to_i]
						@c.send(a, 0)
					else
						$stderr.puts "WARNING: unknown packet received: #{d.inspect}"
				end
				
				purge
			end
		end


		def delegate cmd, param
			return call_command(cmd,param) if has_command?(cmd)
			return Reply.new(REPLY_NOTFOUND, "No command found to handle #{cmd}")
		end

		def send_reply rp
			d = rp.data.to_s.gsub("!", "#EXCL#")
			if rp.code > REPLY_OK
				@c.send("#ERR# "+d, 0)
			else
				@c.send(d, 0)
			end
		end

		def aquire_receipt
			return Time.new.usec.to_s + (rand() % 1000).to_s
		end

	end
end

