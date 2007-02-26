class TimeXP < ActiveRecord::Base
  set_table_name :time_xp
  
  def character
    Character::find(self.cid)
  end

  def ts
    Time::mktime(year, month, day)
  end
end
