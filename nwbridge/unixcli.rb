#!/usr/bin/ruby -w
require 'socket'

client = UNIXSocket.open("/tmp/nwbridge.sock")
while s = gets
	client.send(s, 0)
	client.flush
end
client.close
