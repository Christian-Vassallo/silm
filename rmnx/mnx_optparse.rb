require 'shellwords'
require './getoptlong'

class OptParse < RMNX::CommandSpace
	def initialize
		@optarg = ""
		@optarga = ""
		@optv = {}
		@arg = []
	end
	
	def mnx_getopt(*a)
		a = ["", ""] if a.size != 2
		req_o, str = *a
		return if str == "" || str.nil?
		return if req_o == "" || req_o.nil?
		opt = []

		all = []

		# str = str.join(" ")
		req_o = req_o.strip.split(" ").map{|x| x.strip}.reject{|x| x == ""}
		req_o.each do |n|
			raise "Unknown option #{n}" unless n =~ /^([^=\?]+)(\?|=?)$/
			n = $1
			
			next if all.index(n)

			o = $2 == "="
			o2 = $2 == "?"
			all << n
			# xxxfix kill -h: next if o == "h" && (!o && !o2)
			opt << [(n.size > 1 ? "--" : "-") + n.downcase, o ? GetoptLong::REQUIRED_ARGUMENT : 
				o2 ? GetoptLong::OPTIONAL_ARGUMENT : GetoptLong::NO_ARGUMENT
			]
		end

		@optarg = ""
		@optarga = ""
		@optv = {}
		@arg = []
		
		
		@arg = Shellwords.shellwords(str)
		
		# Fix missing -- for multichar options
		@arg.map! {|x| x =~ /^-[^\s-]{2,}/i ? "-" + x : x }
		
		@arg = GetoptLong.new(@arg, *opt).each {|k,v|
			k = $1 if k =~ /^--?(.+)$/
			v = $1 if v =~ /^=(.+)$/
			@optv[k] = v
		}

		@optarg = str
		@optarga = @arg.join(" ")
	end


	def mnx_getopta(n)
		@arg[n.to_i]
	end
	def mnx_getoptc
		@arg.size.to_s
	end
	def mnx_getopti name
		(@optv[name.downcase] != nil ? 1 : 0).to_s
	end
	def mnx_getoptv name
		@optv[name.downcase]
	end
	def mnx_getoptargs
		@optarg
	end
	def mnx_getoptarga
		@optarga
	end
	def mnx_getoptreset
		@optarg = ""
		@optarga = ""
		@arg = []
		@optv = {}
	end
end

