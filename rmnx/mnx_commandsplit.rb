require 'shellwords'

class CommandSplit < RMNX::CommandSpace
	def initialize
		@cmdx = []
	end

	def mnx_commandsplit text,splitat
		@cmdx = []
		sw = Shellwords.shellwords(text)
		cmd = []
		sw.each do |n|
			if n == splitat
				@cmdx << cmd if cmd.size > 0
				cmd = []
				next
			end
			cmd << n
		end
		@cmdx << cmd if cmd.size > 0
		@cmdx.map! {|cmd|
			ret = " "
			cmd.each do |param|
				if param.index(" ").nil?
					ret << param + " "
				else
					ret << '"' + param + '" '
				end
			end
			ret.strip
		}
		@cmdx.flatten!
		@cmdx.size
	end

	def mnx_commandc
		@cmdx.size
	end
	def mnx_commandget n
		@cmdx[n.to_i]
	end
end
