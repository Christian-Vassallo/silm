#!/usr/bin/ruby 

require 'rubygems'
require_gem 'activerecord'


def field(data, field)
	r = {}
	x = data.split(":")
	r[x.shift] = x.shift while x.size > 0
	r[field]
end

class Audit < ActiveRecord::Base
	set_table_name "audit"
end
ActiveRecord::Base.establish_connection(
	:adapter => 'mysql', :username => 'silm_nwserver', :password => 'NE6uYK2zuV4LEwsh', :database => 'silm_nwserver'
)
puts "connected"

puts "Collecting"
logs = Audit.find(:all, :conditions => ["category='module' and (event='login' or event='logout')"], :order => "date asc")
puts "Collected #{logs.size} audit trails"

# CAP!
limit=820

chr = {}
xp = ""
total_per_login = 0

logs.each do |log|
	xp = field(log.data, "xp")
	if log.event == "login"
		chr[log.player + log.char] = [log.date, xp]
	else
		if (xp = chr[log.player + log.char]).nil?
			$stderr.print log.player + " " + log.char
			$stderr.puts ": logout without login"
		else
			date = xp[0]
			xp = xp[1]
			xp2 = field(log.data, "xp").to_i
			xp = xp.to_i
			diff = xp2-xp
			total_per_login += diff
			next if diff >= 6000 && diff < 6000+limit
			if diff > limit
				print log.player + " " + log.char
				print ": got " + diff.to_s + " on " + log.date.strftime("%c")
				puts ", logged in for " + (log.date - date).to_s + "s"
			end
		end
		chr.delete(log.player + log.char)
	end
end

print "average: "
puts (total_per_login/logs.size).to_s
