require 'rubygems'
require_gem 'activerecord'



class LootAggregator < RMNX::CommandSpace
	class GemChain < ActiveRecord::Base; end

	class LootChain < ActiveRecord::Base; end

	include RMNX::Config

	def initialize
		sql_connect
	end

	def sql_connect
		sql = gety("odbc")
		ActiveRecord::Base.establish_connection(sql)
		ActiveRecord::Base.connection.instance_eval {@connection.reconnect = true}
	end

	def mnx_getgemchainloot areatag, stonetag, aid, cid
		s = ''
		a = []

		loot = GemChain::find_by_sql(['select * from gem_chains where ' +
				'rand() - chance <= 0 and ' +
				'(area = \'\' or ? like area) and ' +
				'(stone = \'\' or ? like stone) ' +
				'order by area, stone `order` asc',
			areatag, stonetag
		])
		
		compact_and_prepare loot
	end
	
	def mnx_getloot racial_type, resref, tag, name, lvar = ""
		s = ''
		a = []

		loot = LootChain::find_by_sql(['select * from loot_chains where ' +
				'rand() - chance <= 0 and ' +
				'(racial_type = -1 or racial_type = ?) and ' +
				'(resref = \'\' or ? like resref) and ' +
				'(tag = \'\' or ? like tag) and ' +
				'(name = \'\' or ? like name) and ' +
				'(lvar = \'\' or ? like lvar) ' +
				'order by racial_type, tag, resref, `name`, `order` asc',
			racial_type, resref, tag, name, lvar
		])
		
		compact_and_prepare loot
	end

	def compact_and_prepare a
		loop do
			reduces = loot.map {|l| l.replace}.max
			break if !reduces || reduces == 0

			for i in 0...loot.size do
				r = loot[i].replace
				next if r == 0
				
				loot[i].replace = 0
				r.times {
					loot.delete_at(i-1)
					i-=1
					break if i <= 0
				}
				break
			end
		end

		loot = loot.map{|x| x.loot}.join("#").gsub(/##+/, '#')
		return loot
	end
end
