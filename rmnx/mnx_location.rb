require 'rubygems'

class LootAggregator < RMNX::CommandSpace
	include RMNX::Config

	def initialize
	end

	def mnx_locationcount a
		l = gety("locations")
	end

	def mnx_location a
		l = gety("locations")
		

		return loot
	end
end
