#!/usr/bin/ruby -w
require 'socket'

client = UNIXSocket.open("./nwbridge.sock")
while s = gets
	client.send(s, 0)
end
client.close
