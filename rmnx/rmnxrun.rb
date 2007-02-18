#!/usr/bin/env ruby
require 'rubygems'
require 'rmnx'

require 'base64'
require 'digest/md5'
require 'digest/sha1'
require 'parsedate'

require 'mnx_optparse'
require 'mnx_commandsplit'
require 'mnx_temp'
require 'mnx_jabber'


Thread.abort_on_exception = true

include RMNX::Config


class Misc < RMNX::CommandSpace
	def initialize
	end

	def mnx_setpc(*a)
	end

	def mnx_slogan
		sl = gety("slogans")
		sl[rand(sl.size)]
	end

	def mnx_date
		`date`.strip
	end
	def mnx_strcmp a, b
		a <=> b
	end
	def mnx_strsucc x
		x.succ
	end

	def mnx_strpred x
		x.pred
	end
	def mnx_strswpcase x
		x.swapcase
	end
	def mnx_uptime
		'module up since: ' + File.stat("../nwserver/currentgame.0/").mtime.to_s +
		' on "' + `uname -a`.strip +
		'", host uptime: ' + `uptime`.strip
	end
end

class TextHandler < RMNX::CommandSpace
	MODE_TALK = 1
	MODE_SHOUT = 2
	MODE_WHISPER = 4
	MODE_PRIVATE = 8
	MODE_PARTY = 16
	MODE_DM = 32

	MODE_DM_MODE = 65
	MODE_COMMAND = 128
	MODE_FORCETALK = 256
	
	REPLACE = {
		/scheppernt/, "scheppernd"
	}

	def mnx_ontext t, mode
		mode = mode.to_i
		if !(mode & MODE_DM_MODE) && (mode & MODE_TALK || mode & MODE_WHISPER)
			REPLACE.each {|k,v|
				t.gsub! k, v
			}
			return "a" + t
		end

		return "i" + t
	end
end


class RXSplit < RMNX::CommandSpace
	def initialize
		@split = []
	end

	def mnx_split rx, text
		@split = text.split(Regexp.new(rx))
		return @split.size
	end

	def mnx_splitargc
		@split.size
	end

	def mnx_splitarg n
		@split[n.to_i]
	end
end

#s.add_command("timedesc2int", proc {|t|
#	# parse stuff
#	0
#} )
# command: ["setpc", "Ichshadon", "Marteon Willows", aid = "25", cid = "58"]
# s.add_command("setpc", proc {})
serverdata = gety("listen", {})

port = (ARGV.shift || serverdata['port'] || 2800).to_i
s = RMNX::Server.new(serverdata['listenaddr'] || "127.0.0.1", port)
s.add_command_space(RXSplit.new)
s.add_command_space(TextHandler.new)
s.add_command_space(Misc.new)
s.add_command_space(CommandSplit.new)
s.add_command_space(OptParse.new)

s.add_command_space(CommandTemperature.new)

s.add_command_space(MnxJabber.new)

puts "Registered all commands."
puts "okay, good to go."
while str = gets do
	break if str.nil?
	next if str.strip == ""
	str.chomp!
	cmd, *p = str.split("!")
	puts "Executing #{cmd}(#{p.map{|n| n.inspect}.join(', ')})"
	reply = s.call_command(cmd, p)
	puts " Result: %s" % reply.to_s
end
puts "terminated because input stream barfed"
