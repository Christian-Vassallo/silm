#!/usr/bin/ruby

trap "INT", proc {
	exit 0
}

loop do
	$stdout.puts(gets.strip.reverse)
	$stdout.flush
end
