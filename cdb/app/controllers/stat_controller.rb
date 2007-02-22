class StatController < ApplicationController
	before_filter :authenticate
	before_filter :enter_details

	before_filter :authenticate_char_view

	def mentor
		@totalmentor = MentorData.find_by_sql("select aid,sum(xp) as xp from mentordata group by aid order by xp desc")
		#:all, :group => "xp", :order => "xp desc")
		@mentor = MentorData.find(:all, :order => "aid asc, xp desc")
	end

	def time_xp
		@for_cid = (params[:id] || 0).to_i

		@tend = Time.now - Time.now.hour * 3600
		@tstart = @tend - (3600 * 24 * 30) # 1mon
		@tend = Time.mktime(params[:tend][:year], params[:tend][:month], params[:tend][:day]) if params[:tend]
		#@tstart = Time.mktime(params[:tstart][:year], params[:tstart][:month], params[:tstart][:day]) if params[:tstart]
		
		# @tend = @tstart if @tend < @tstart

		sort_by = params[:sort_by]
		sort_order = params[:sort_order] == 'asc' ? 'asc' : 'desc'

		where = " where "
		where += " unix_timestamp(str_to_date(concat(day, '.', month, '.', year), '%%d.%%m.%%Y')) <= %d" % [@tend.to_i] 
		where += " and unix_timestamp(str_to_date(concat(day, '.', month, '.', year), '%%d.%%m.%%Y')) >= %d" % [@tstart.to_i] 
		where += " and cid = %d" % [@for_cid] if @for_cid > 0
		@where = where	
		@xp_total = TimeXP.find_by_sql("select sum(xp) as xp from time_xp %s" % where)

		@xp_per_cid = TimeXP.find_by_sql("select cid, sum(xp) as xp, \
			min(day) as min_day, min(month) as min_month, min(year) as min_year, \
			max(day) as max_day, max(month) as max_month, max(year) as max_year \
			from time_xp %s group by cid order by xp %s" % [where, sort_order])
		
		@xp_per_cid_per_month = TimeXP.find_by_sql("select cid, xp, month, year from time_xp %s order by year, month %s" % [where, sort_order])
		
		@xp_per_cid_per_day = TimeXP.find_by_sql("select cid, xp, day, month, year from time_xp %s order by year, month, day %s" % [where, sort_order])

		@xp_per_month = TimeXP.find_by_sql("select month,year,sum(xp) as xp from time_xp %s group by year,month order by year, month %s" % [where, sort_order])
		
		@xp_per_day = TimeXP.find_by_sql("select day,month,year,sum(xp) as xp from time_xp %s group by day,year,month order by year, month, day %s" % [where, sort_order])
	end
end
