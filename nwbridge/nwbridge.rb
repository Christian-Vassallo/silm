#!/usr/bin/ruby -w
require 'socket'
require 'optparse'

$password = "default"

$port = 1400

$allowed_commands = %w{
	status clientinfo
	
	kick 

	listbans banip bankey banname
	unbanip unbankey unbanname

	maxclients

	say
}

class String
	def sane_command
		return (self.split(/\s/)[0] || "").gsub(/[^a-z]/i, "")
	end
end
class TCPSocket
	def TCPSocket(*a)
		super(*a)
		@authed = false
	end

	attr_accessor :authed

	def s
		self.peeraddr[3] + "/" + peeraddr[2] + ":" + peeraddr[1]
	end
end

$run = "sh Run"
$force = false

OptionParser.new {|o|
	o.on("-p N", "--port N", "specify socket") {|x|
		$sock = x
	}
	o.on("-r S", "--run R", "the command to run") {|x|
		$run = x
	}
	o.on("-f", "--force", "force even if socket exists") {
		$force = true
	}
	o.on( "--read-pass S", "read password from file") {|f|
		$password = IO::read(f).strip
	}
	o.on("-h", "--help", "help") {
		puts o
		exit 0
	}
}.parse!


trap "INT", proc {
	log "Terminating", "X"
	exit 0
}

Thread.abort_on_exception = true

$u = TCPServer.open($port)
puts "listening on #{$port}"
$p = IO::popen($run, "w+")

$cli = []

def log message, level = "A", sendcli = false
	send_to_all_clients("nwbridge:#{level}> #{message}") if sendcli
	$stdout.puts(level + "> " + message.strip)
end

def _p_read
	buf = ""
	log "reading nw"
	begin
	loop do
		buf += $p.sysread(1)
		while buf =~ /^([^\n\r]+)\r?\n(.*)$/
			str = $1
			buf = $2
			send_to_all_clients str
			log str, "nw"
		end
	end
	rescue Exception => e
		log "program terminated: #{e.to_s}"
	end
	exit 0
end

def _client_read c
	begin
		c.each_line do |str|
			str = str.chomp
			if !c.authed
				if str == $password
					c.authed = true
					c.puts("Authenticated.")
				else
					c.close
				end
				next
			end

			handle_client_line c, str
			log str.strip, "D:us"
		end
	rescue Exception => e
		log "client gone: #{e.to_s}"
	end
	$cli.delete(c)
end

def _accept_client
	loop do
		c = $u.accept
		$cli << c
		Thread.new { _client_read(c) }
	end
end

def handle_client_line client, str
	sane = str.sane_command
	
	if $allowed_commands.index(sane).nil?
		client.puts("Unknown command #{sane}.")
		# send_to_all_clients("Client tried to mess up by issuing command `#{sane}'!")
		return
	end

	send_to_p str
	send_to_all_clients str, client
end

def send_to_all_clients str, except = nil
	$cli.each {|c|
		next if c == except
		next if !c.authed
		c.puts str
	}
end

def send_to_p str
	log str, "us:nw"
	$p.syswrite(str.strip)
	sleep 0.1
	$p.syswrite("\n")
	sleep 0.1
	$p.syswrite("\n")
end

accept_thread = Thread.new { _accept_client }
p_read_thread = Thread.new { _p_read }

accept_thread.join

#while s = $stdin.gets
#end
