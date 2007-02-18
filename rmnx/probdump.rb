require 'libmnx_weather'
require 'lib_core'
require 'yaml'

include Weather::Const
include Weather::Tables
include Weather::Probabilities

def get_temp_range t
	x = case t
		when T_X
			[-20,0]
		when T_C
			[0,5]
		when T_M
			[5,15]
		when T_W
			[15,30]
		when T_H
			[30,45]
		when T_V
			[45,60]
	end
	x.map{|n|n.to_f}
end


# Returns the table entry for this weather data
def get_weather_for season, hour, d100
	r = {}
	%w{river open north}.each do |area|
		prob = PROBABILITY[season][area].index_of_range(d100)
		if prob != nil
			r[area] = WEATHER_TABLES[season][prob]
		end
	end
	r['indoor'] = [T_M, W_NONE, P_INDOOR]
	r['desert'] = [T_H, W_VARIES, P_CLEAR]
	r
end



def get_perc season, count 
	a = {
		'temp' => {},
		'wind' => {},
		'prec' => {},
	}
	$fields.each {|e| a[e].default = 0 }

	for i in 1..count do
		w = rand(100) + 1
		w = get_weather_for(season, 12, w)
		w = w['river']
		temp, wind, prec = *w
		a['temp'][temp] += 1
		a['wind'][wind] += 1
		a['prec'][prec] += 1
	end
	a
end


def prep_hash h, count
	$fields.each {|f|
		h[f].each {|k,v|
			v = 100/(count/v.to_f)
			h[f][k] = v.to_s + "%"
		}
	}
	h['temp'].each {|k,v|
		h['temp'].delete(k)
		k = get_temp_range(k).join(" - ") if k.is_a?(Fixnum)
		h['temp'][k] = v
	}
	h['wind'].each {|k,v|
		h['wind'].delete(k)
		h['wind'][case k
			when 1
				"fair"
			when 2
				"varies"
			when 4
				"storm"
			else
				"none"
		end] = v if k.is_a?(Fixnum)
	}
	h['prec'].each {|k,v|
		h['prec'].delete(k)
		h['prec'][case k
			when 1
				"clear"
			when 2
				"rain"
			when 4
				"downpour"
			when 8
				"snow"
			when 16
				"sleet"
			when 32
				"fog"
			when 64
				"hail"
			when 128
				"heavy snow"
			when 256
				"thunderstorm"
			when 512
				"sandstorm"
		end] = v if k.is_a?(Fixnum)
	}
	h
end

def show_hash(h)
	y h
end

$fields = %w{temp wind prec}

count = 3000

puts "Winter:"
h = prep_hash get_perc(S_WINTER, count), count
show_hash h

puts "Spring:"
h = prep_hash get_perc(S_SPRING, count), count
show_hash h

puts "Summer:"
h = prep_hash get_perc(S_SUMMER, count), count
show_hash h

puts "Fall:"
h = prep_hash get_perc(S_FALL, count), count
show_hash h
