#!/usr/bin/ruby -w
require 'socket'

trap "INT", proc {
	File.unlink("./nwbridge.sock")
	exit 0
}

Thread.abort_on_exception = true

$u = UNIXServer.open("./nwbridge.sock")
$p = IO::popen("ruby testnw.rb", "w+")
$cli = nil

def _read_nw
	puts "A> reading nw"
	while str = $p.gets
		puts "nw> " + str.strip
		$cli.puts str.strip if $cli
	end
	puts "E> not reading nw"
end

def _read_us 
	puts "A> new client"
	begin
		while str = $cli.gets
			puts "us> " + str.strip
			_write_nw str.strip
		end
	rescue Exception => e
		puts "E> socket terminated: #{e.to_s}"
		puts e.backtrace.join "\n"
	end
	$cli = nil
end

def _accept_us
	loop do
		$cli = $u.accept
		Thread.new { _read_us }
	end
end

def _write_us str
	$cli.puts str.strip if $cli
end

def _write_nw str
	puts "Writing nw> " + str
	$p.puts str.strip
	$p.flush
	_write_us str.strip
end

read_nw_thread = Thread.new { _read_nw }
read_us_thread = Thread.new { _accept_us }

while $stdin.gets
end
