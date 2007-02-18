#  SQL Abstraction layer to extend nwnx/aps


require 'dbi'

class SQLCommand < RMNX::Command
	def initialize
		@handles = {}
	end
	
	def get_cmd; "sql"; end
	
	def on_cmd p
		case p[0]
		when "connect"
			db = p[1]
			handle = aquire_handle(db, "nwnx", "password")
			ok(@handles.index(handle))
		when "prepare"
			idx    = p[1]
			sqlstr = p[2]
			*vars  = p[3,-1]
			handle = aquire_handle_by_index(idx)
			state  = handle.prepare(sqlstr, vars)
			
		when "query"
			handle = p[1]
			query  = p[1]
			
			ok()
		when "escape"
			
		else
			err("No such command: #{p[0]}")
		end
	end

	private
	def aquire_handle db, user, pass, host = "localhost", port = 3306
		istr = "DBI::MySQL::#{host}:#{port}:#{db}:#{user}:#{pass}"
		if @handles[istr].nil?
			@handles[istr] = DBI.connect('DBI:Mysql:#{db}', '#{user}', '#{pass}')
		end
		return @handles[istr]
	end
	def aquire_handle_by_index idx
		if @handles[idx].nil?
			raise Exception("No such handle.")
		else
			@handles[idx]
		end
	end
end
