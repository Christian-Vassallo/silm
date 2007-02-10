#!/usr/bin/ruby 
require 'yaml'

require 'rubygems'
require_gem 'activerecord'

$mask = Regexp.new(ARGV.shift || ".*")


def field(data, field)
	r = {}
	x = data.split(":")
	r[x.shift] = x.shift while x.size > 0
	r[field]
end

class Account < ActiveRecord::Base; end
class Character < ActiveRecord::Base; end

class Audit < ActiveRecord::Base
	set_table_name "audit"
end
ActiveRecord::Base.establish_connection(
	:adapter => 'mysql', :username => 'silm_nwserver', :password => 'NE6uYK2zuV4LEwsh', :database => 'silm_nwserver'
)
puts "Collecting ALL audit trails"
logs = Audit.find(:all, :conditions => ["category='module' and (event='startup' or event='login' or event='logout')"], :order => "date asc")
puts "Collected #{logs.size} audit trails."

# The start date of trail collection (aka the first trail)
$start = nil
# The end date of trail collection (aka the last trail)
$end = nil


$cidmap = {}

# Maps "account->charname" -> statistical data
$data = Hash.new()
$default = {
	:xp => {
		:per_day => Hash.new(0),
			#'20061201' => 0,
		:per_month => Hash.new(0),
			#'200612' => 0,
	},
	:time => {
		:per_day => Hash.new(0),
		:per_month => Hash.new(0),
	}
}

this_day = ""
this_month = ""

def get_cid(acc, char)
	a = Account.find(:first, :conditions => ['account = ?', acc])
	return 0 if !a
	c = Character.find(:first, :conditions => ['account = ? and `character` = ?', a.id, char])
	return 0 if !c
	return c.id.to_i
end

# Holds characters for parsing between login and logout
chr = {}

xp = 0
identifier = ""
logs.each do |log|
	identifier = log.player + "|" + log.char
	next unless identifier =~ $mask

	# Set the starting ts
	$start = log.date if !$start
	
	# Extract the XP part from this log entry
	xp = field(log.data, "xp").to_i

	$data[identifier] = $default.dup if !$data[identifier]

	case log.event
		when "login"
			chr[identifier] = [log.date, xp]
	when "startup"
		# cleanup chr data, because we did a restart
		chr = {}
	when "logout"
		if (tmp = chr[identifier]).nil?
			$stderr.print log.player + " " + log.char
			$stderr.puts ": logout without login"
		else
			date = tmp[0]
			xp = tmp[1]

			xp2 = field(log.data, "xp").to_i
			xp = xp.to_i
			diff = xp2 - xp

			# The duration for this login
			duration = (log.date - date).to_i

			#diff -= 6000 if diff >= 6000
			if diff < -1000
				puts "Warning: Collected a diff of of #{diff}" if (diff != 5000 && diff != 6000)
				#next
			end
			
			tmp_day = log.date.strftime("%Y%m%d")
			tmp_month = log.date.strftime("%Y%m")

			# If a new day has started
			if this_day != tmp_day
				# update all data for this day
				#
				# login duration for this day

				$data[identifier][:xp][:per_day][this_day] += diff

				$data[identifier][:time][:per_day][this_day] += duration
				

				# Start a new day
				this_day = tmp_day
			end

			if this_month != tmp_month
				# Put this last log item into this month
				
				$data[identifier][:xp][:per_month][this_month] += diff
				$data[identifier][:time][:per_month][this_month] += duration
				# then start a new one
				this_month = tmp_month
			end
			
			$end = log.date
			
		end

		chr.delete(identifier)
	end
end


# Global statistics
$average = {
	:xp => {
		:per_day => 0,
		:per_day_c => 0,
		:per_month => 0,
		:per_month_c => 0,
	},

	:time => {
		:per_day => 0,
		:per_day_c => 0,
		:per_month => 0,
		:per_month_c => 0,
	},
}

$data.each do |char, data|

	v = 0;vc = 0
	data[:xp][:per_day].each do |daydesc, xp|
		v += xp; vc += 1
	end
	$average[:xp][:per_day] += v
	$average[:xp][:per_day_c] += vc
	
	v = 0; vc = 0
	data[:xp][:per_month].each do |monthdesc, xp|
		v += xp; vc += 1
	end
	$average[:xp][:per_month] += v
	$average[:xp][:per_month_c] += vc
	
	v = 0; vc = 0
	data[:time][:per_day].each do |monthdesc, xp|
		v += xp; vc += 1 if xp > 0
	end
	$average[:time][:per_day] += v
	$average[:time][:per_day_c] += vc
	
	v = 0; vc = 0
	data[:time][:per_month].each do |monthdesc, xp|
		v += xp; vc += 1 if xp > 0
	end
	$average[:time][:per_month] += v
	$average[:time][:per_month_c] += vc
end

$average[:xp][:per_day] /= $average[:xp][:per_day_c] if $average[:xp][:per_day_c] > 0
$average[:xp][:per_month] /= $average[:xp][:per_month_c]  if $average[:xp][:per_month_c] > 0
$average[:time][:per_day] /= $average[:time][:per_day_c]  if $average[:time][:per_day_c] > 0
$average[:time][:per_month] /= $average[:time][:per_month_c]  if $average[:time][:per_month_c] > 0

[:per_day_c, :per_month_c].each do |whee|
	[:xp, :time].each do |whoo|
		$average[whoo].delete(whee)
	end
end

p $average
#exit

row = 0

$f = File.new(ARGV.shift || "monthly_data.html", "w")
$f << "<html><head><style> body,table,td {font-family:verdana;font-size:10px;border: 1px solid grey;}</style><body>"
$f << "<br>Generated on #{Time.now.strftime('%c')}"
$f << "<br>Timeframe of data #{$start.strftime('%c')} -> #{$end.strftime('%c')}"
$f << "<br>avgratio #{$avgratio}, botratio #{$bottomratio}, topratio #{$topratio}"
$f << "<table width='100%'>"
$f << "<tr><td><b>char</b></td><td><b>" + $allmonths.join("</b></td><td><b>") + "</b></td><td><b>total</b></td></tr>"
$f << "<tr><td><i>average/day/month</i></td><td>" + $average.join("</td><td>") + "</td><td><i>per login: "+(total_per_login.to_f/total_logins).to_s+"</i></td></tr>"
$xp_per_month.sort.each do |char,achar|
	puts char
	mi = []
	t_xp = 0
	t_time = 0
	achar.sort.each do |month,val|
		xp, time = *val
		t_xp += xp
		t_time += time
		ratio = xp.to_f/ (time.to_f / 1000)
		ratio_s = "%.3f" % [ratio]
		puts " " + month + ": " + xp.to_s
		ratio_s = "<font color='red'>" + ratio_s + "</font>" if ratio > 70
		ratio_s = "<font color='orange'>" + ratio_s + "</font>" if ratio < 15
		mi << [xp.to_s, time.to_s, ratio_s]
	end
	ratio = t_xp.to_f/ (t_time.to_f / 1000)
	ratio_s = "%.3f" % [ratio]
	ratio_s = "<font color='red'>" + ratio_s + "</font>" if ratio > 70
	ratio_s = "<font color='orange'>" + ratio_s + "</font>" if ratio < 15
	$f << "<tr>"
	$f << "<td>#{char}</td>" + ("<td>-1</td>" * ($allmonths.size - mi.size)) + "<td>" + mi.map{|n| n.join("<br>")}.join("</td><td>") + "</td>"
	$f << "<td>" + [t_xp, t_time, ratio_s].join("<br>") + "</td>"
	$f << "</tr>"
	row += 1
	if row % 25 == 0
		$f << "<tr><td><b>char</b></td><td><b>" + $allmonths.join("</b></td><td><b>") + "</b></td><td><b>total</b></td></tr>"
	end
end

$f << "</table></body></html>"
$f.close
