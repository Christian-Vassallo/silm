class StatController < ApplicationController
	before_filter :authenticate
	before_filter :enter_details

	before_filter :authenticate_char_admin, :only => %w{mentor}

	def index
	end

	def mentor
		@totalmentor = MentorData.find_by_sql("select aid,sum(xp) as xp from mentordata group by aid order by xp desc")
		#:all, :group => "xp", :order => "xp desc")
		@mentor = MentorData.find(:all, :order => "aid asc, xp desc")
	end
end
