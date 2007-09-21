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
		attr_accessor :serial

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
		
		# keep this many serial repsonses in memory
		BACKDROP = 500

		attr_reader :startup
		
		def queue
			@rcp
		end

		def initialize(host, port) #, peerhost, peerport)
			@host, @port = host, port
			@peerhost, @peerport = nil, nil
			@s = UDPSocket.new
			@c = nil
			@s.bind(host, port)
			@t = Thread.new { _t }
			@commandspace = []
			@startup = Time.now

			@serials = {}
			@last_serial = -1
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
				# d = d.gsub(/!$/, "")

				serial, cmd, *param = d.split("!")
				if serial.to_i < 0
					fail "Serial invalid: #{serial}. This version of rmnx is incompatible to your mnx API."
					exit 1
				end
				serial = serial.to_i
				for i in 0...param.size do
					param[i].gsub!("#EXCL#", "!")
				end
				
				$stderr.puts "#{serial}: #{cmd} <- #{param.inspect}"
				
				# oneshot-request that does not request a reply, just process it.
				if 0 == serial
					delegate(cmd, param)
					next
				end


			
				# This was a previously requested serial
				# Just send it out
				if nil != @serials[serial]
					tstamp, reply = *@serials[serial]
					reply.serial = serial

					$stderr.puts "Warning: Previously requested serial re-requested. Sending old reply: #{serial - 1}"

					send_reply(reply)

				# Its a new request/unknown serial
				else

					# But its not the next in line! Erk.
					# We can't do anything about that, though.
					# Just blow it over.
					if serial - 1 != @last_serial
						$stderr.puts "Warning: We seem to have MISSED a serial: #{serial - 1}"
					end


					reply = delegate cmd, param
					reply.serial = serial


					@serials[serial] = [Time.now, reply]
					
					send_reply(reply)


				end

					

				if -1 == @last_serial
					$stderr.puts "New startup: setting initial serial to #{serial}"
				end
	
				@last_serial = serial
				
				# XXX this needs optimisation
				if @serials.size > BACKDROP * 2
					@serials.sort {|a,b|
						# sort by timestamp descending (b > a)
						b[1][0] <=> a[1][0]
					}[BACKDROP..-1].map{|x| x[0]}.each {|k|
						@serials.delete(k)
					}
				end
			end
		end


		def delegate cmd, param
			return call_command(cmd,param) if has_command?(cmd)
			return Reply.new(REPLY_NOTFOUND, "No command found to handle #{cmd}.")
		end

		def send_reply rp
			
			d = rp.serial.to_s + "!" + rp.data.to_s.gsub("!", "#EXCL#")
				
			$stderr.puts "  #{rp.serial.to_s}:   -> #{d.inspect}"

			if rp.code > REPLY_OK
				@c.send("#ERR# " + d , 0)
			else
				@c.send(d , 0)
			end
		end

	end
end

