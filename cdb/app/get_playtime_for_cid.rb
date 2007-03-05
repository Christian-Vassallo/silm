#!/usr/bin/ruby 

require 'rubygems'
require_gem 'activerecord'

cid = ARGV.shift or fail "No char specified."
cid = "%" + cid + "%"

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
logs = Audit.find(:all, :conditions => ["category='module' and (event='login' or event='logout' or event='startup') and `char` like ?", cid], :order => "date asc")
puts "Collected #{logs.size} audit trails"

alltime = 0

login = nil

logs.each do |log|
  case log.event
  when 'startup', 'logout'
    if login != nil
      alltime += (log.date - login.date)
      login = nil
    end

  when 'login'
    login = log
  end
end 

puts "all time in seconds: #{alltime}"
