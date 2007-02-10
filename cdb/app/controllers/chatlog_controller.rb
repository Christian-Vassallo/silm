class ChatlogController < ApplicationController
	before_filter :authenticate_audit_admin

	def index
		search = (params['chatlog_search'] || "").strip
		@csearch = search
		search = search.split(" ").reject{|x| x.strip == ""}.compact
		#cond = "!(mode & 0) or ( "
		cond = "!(mode & 0) or ( "
		conda = []
		if search.size > 0
			search.each {|s|
					s = '%' + s + '%'
					cond += " "
					cond += " ("
					cond += " character_s like ? "
					cond += " or account_s like ? "
					cond += " or area like ? "
					cond += " ) or "
					conda << [s] * 3
			}
		end
		cond += " 1=0 )"
		order = "timestamp asc"
		perpage = 100
		if search.size > 0
			@log_pages, @logs = paginate :chatlogs, :order => order, :per_page => perpage, :conditions => [cond, conda].flatten
		else
			@log_pages, @logs = paginate :chatlogs, :order => order, :per_page => perpage, :conditions => [cond, conda].flatten
		end
	end

end
