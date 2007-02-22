class TimeXP < ActiveRecord::Base
	set_table_name :time_xp
	
	def character
		Character::find(self.cid)
	end
end
