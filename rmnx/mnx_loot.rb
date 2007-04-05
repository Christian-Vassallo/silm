require 'rubygems'
require_gem 'activerecord'


class Loot < ActiveRecord::Base
end

class LootAggregator < RMNX::CommandSpace
	include RMNX::Config

	def initialize
		sql_connect
	end

	def sql_connect
		sql = gety("odbc")
		ActiveRecord::Base.establish_connection(sql)
		ActiveRecord::Base.connection.instance_eval {@connection.reconnect = true}
	end
	
	def mnx_getloot racial_type, resref, tag, name, lvar = ""
		s = ''
		a = []

		loot = Loot::find_by_sql(['select loot from loots where ' +
				'rand() - chance <= 0 and ' +
				'(racial_type = -1 or racial_type = ?) and ' +
				'(resref = \'\' or ? like resref) and ' +
				'(tag = \'\' or ? like tag) and ' +
				'(name = \'\' or ? like name) and ' +
				'(lvar = \'\' or ? like lvar) ' +
				'order by racial_type, resref, tag, lvar asc',
			racial_type, resref, tag, name, lvar
		])
		loot = loot.map{|x| x.loot}.join("#").gsub(/##+/, '#')
		return loot
	end
end
