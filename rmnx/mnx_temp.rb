require 'yaml'
require 'libmnx_weather'
require 'lib_core'

require 'rubygems'
require_gem 'activerecord'

class WeatherOverride < ActiveRecord::Base; end



class Mask < String
	def mask_matches? specimen, case_sens = false
		pattern = "^#{Regexp.escape(self)}$"
		pattern.gsub!(/\\\*/, '.*')
		pattern.gsub!(/\\\?/, '.')
		return (specimen =~ Regexp.new(pattern,
			case_sens ? 0 : Regexp::IGNORECASE)) != nil
	end
end


class CommandTemperature < RMNX::CommandSpace
	include RMNX::Config

	include Weather::Const
	include Weather::Tables
	include Weather::Probabilities


	def d(n)
		1 + rand(n)
	end

	def d100
		d 100 
	end

	def force_connect
		if Time.now.to_i - @last > 60*60
			puts "Reconnecting to SQL"
			begin
				ActiveRecord::Base.establish_connection(gety("odbc"))
			rescue Exception => e
				puts "Ex: #{e.to_s}"
			end
		end
	
		@last = Time.now.to_i
	end

	# updates overrides each n seconds
	def _t_ovr_upd
		loop do
			update_overrides
			sleep 300
		end
	end

	def update_overrides
		# @override = 
	end

	def initialize
		# be deterministic!
		@key = 220 # Time.now.to_i
		puts "RandKey is: #{@key}"
		File.open("randkey", "w") {|f| f.write(@key.to_s)}
		srand(@key)
		@mod = 1
		@weather = 77
		@every_n_ig_days = 2
		@next_in = -1 #3 
		@last_day = 0
		@last_weather_dump = 0
		@override = []
		@last = 0
		# Thread.new { _t_ovr_upd }
	end
	
#string TILESET_RESREF_BEHOLDER_CAVES     = "tib01";
#string TILESET_RESREF_CASTLE_INTERIOR   = "tic01";
#string TILESET_RESREF_CITY_EXTERIOR     = "tcn01";
#string TILESET_RESREF_CITY_INTERIOR     = "tin01";
#string TILESET_RESREF_CRYPT             = "tdc01";
#string TILESET_RESREF_DESERT            = "ttd01";
#string TILESET_RESREF_DROW_INTERIOR     = "tid01";
#string TILESET_RESREF_DUNGEON           = "tde01";
#string TILESET_RESREF_FOREST            = "ttf01";
#string TILESET_RESREF_FROZEN_WASTES     = "tti01";
#string TILESET_RESREF_ILLITHID_INTERIOR = "tii01";
#string TILESET_RESREF_MICROSET          = "tms01";
#string TILESET_RESREF_MINES_AND_CAVERNS = "tdm01";
#string TILESET_RESREF_RUINS             = "tdr01";
#string TILESET_RESREF_RURAL             = "ttr01";
#string TILESET_RESREF_RURAL_WINTER      = "tts01";
#string TILESET_RESREF_SEWERS            = "tds01";
#string TILESET_RESREF_UNDERDARK         = "ttu01";
# City_Rural_Builder_Base = tcr10
# Mountain: tsh01
# DC Villages: tdcr1
	def get_area_type resref, tileset, mask
		
		return 'indoor' if A_INTERIOR == mask & A_INTERIOR
		
		# Ascore is desert
		return 'desert' if %w{ascore02 ascore03 ascore04 ascore05 ascore19 ascore07 ascore09 ascore10 ascore11}.index(resref)
		
		# huegellaender are river
		# return 'river' if %w{ascore20 ascore21 ascore23 area028 area006 area039}.index(resref)

		return case tileset
			when "tib01", "tibc0i1", "tin01", "tdc01", "tid01", "tde01", "tii01", "tdm01", 'tds01', 'ttu01',
					'tdr01'
				'indoor'
			when 'tts01', 'tti01', 'tsh01'
				'north'
			when  'invalid' #xxx swamps
				'open'
			when 'ttd01' #desert
				'desert'
			else
				'open'
				#'river'
		end
	end

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

		if hour > 20 || hour < 6
			r['north'][0] = T_X
			r['desert'][0] = T_C
		end
		r
	end


	def get_override atype, year, month, day
		return nil
		force_connect	
		d = WeatherOverride.find(:first, :conditions => [
			'atype = ? and date("?-?-?") >= date(concat(ayear, "-", amonth, "-", aday)) and date("?-?-?") <= date(concat(zyear, "-", zmonth, "-", zday))',
				atype, year, month, day, year, month, day
			]
		)
		if d.nil?
			return d
		else
			return [d.temp, d.wind, d.prec]
		end
	end

	def set_override atype, ayear, amonth, aday, zyear, zmonth, zday, temp, wind, precip
		#force_connect	
		#return false if ayear > zyear ||
		#	(ayear >= zyear && amonth > zmonth) ||
		#	(ayear >= zyear && amonth >= zmonth && aday > zday)
		#d = WeatherOverride.new(:atype => atype, :ayear => ayear, :amonth => amonth,
		#	:aday => aday, :zyear => zyear, :zmonth => zmonth, :zday => zday,
		#	:temp => temp, :wind => wind, :prec => precip)
		#d.save
		true
	end


	CREATURES = [%w{Slaads Phaerimm Zwergen Drow Blutmuecken Spielleitern Gelantinewuerfel W20s Gnollen},
			%w{Auge Strickdrache Druiden Balor Archons Steingiganten Rasenmaeher Eisgiganten},
			%w{Elfen Moohle Hidan Triade},
			['Harald Hohenfels', 'Buechern']
		].flatten

	def randomfunny
		# each 10 minutes a new random funneh?
		#
		srand
		case rand(10)
		when 0
			if 0 == rand(8)
				c = CREATURES[rand(CREATURES.size)]
				c = c[0..-2] if c[-1] == ?n
				c + " von Wetterstation ueberannt."
			else
				"Wetterstation von " + CREATURES[rand(CREATURES.size)] + " ueberannt."
			end
		end

	end

	# Returns the weather array for this type of area
	# [temp, wind, prec]
	def get_weather_array(atype, year, month, day, hour, minute)
		season = get_season(year, month, day)	
		weather = get_override(atype, year, month, day)
		if weather.nil?
			if true # false # use old code
				srand(@key + year + month + (day/@every_n_ig_days))
				@weather = rand(100)+1
			else
				@last_day = day if @last_day == 0
				if day != @last_day
					@next_in -= 1
					@last_day = day
				end
				if 0 >= @next_in
					@every_n_ig_days = rand(3)+1 + rand(2) > 0 ? rand(3) : 0
					@next_in = @every_n_ig_days
					srand(@key + year + month + day)
					@weather = rand(100)+1
					puts "\nNew weather, next in #{@next_in} days\n"
				end
			end

			weather = get_weather_for(season, hour, @weather)[atype]
		end
		weather
	end
	
	# returns the temperature range array for the current moment
	# [min, max, avg, cur]
	def get_weather_temp(weather_array, year, month, day, hour, minute)
		temp = weather_array[0]
		# Calculate the current temperature
		temp_range = get_temp_range temp
		# srand(@mod + year * 1000 + month * 15 + day)
		diff = (hour<6||hour>18 ? 16 : 8)
		srand(@key + year + month + day)
		mod = -diff + rand(diff * 2)
		temp_range[0] -= mod.abs
		temp_range[1] -= mod.abs
		
		temp_min = temp_range[0]
		temp_max = temp_range[1]
		temp_avg = temp_range[1]
		temp_cur = hour > 12 ? temp_max - hour + 4 : temp_min + hour + 8
		
		[temp_min, temp_max, temp_avg, temp_cur]
	end
	def get_weather_wind(weather_array, year, month, day, hour, minute)
		[0, 0, 0, 0]
	end
	
	# Returns the weather name for this weather_array
	def get_weather_name weather_array
		return case weather_array[2]
			when P_CLEAR
				"Kaum Wolken"
			when P_RAIN
				"Regen"
			when P_DOWNPOUR
				"Regenschauer"
			when P_SNOW
				"Schnee"
			when P_SLEET
				"Eisregen"
			when P_FOG
				"Nebel"
			when P_HAIL
				"Hagel"
			when P_HSNOW
				"Starke Schneewirbel"
			when P_THUNDERSTORM
				"Gewitter"
			when P_SANDSTORM
				"Sandsturm"
			when P_INDOOR
				"Innengebiet"
		end
	end



	def mnx_getweather resref, tileset, mask, year, month, day, hour, minute
		fogdata = gety("fogdata")

		mask = mask.to_i; hour = hour.to_i; minute = minute.to_i
		year = year.to_i; month = month.to_i; day = day.to_i
		
		# save the current date for future reference
		@year = year; @month = month; @day = day; @hour = hour; @minute = minute
		#dumpweather

		atype = get_area_type(resref, tileset, mask)
		weather = nil

		if "arnw_druidenhain" == resref
			weather = [
				T_M, W_F, P_C
			]
		end

		weather = get_weather_array(atype, year, month, day, hour, minute) if !weather
		precip = weather[2]

		if A_INTERIOR == mask & A_INTERIOR
			text = "Wetter: Innengebiet."
		else
			# Calculate the current temperature
			temp_range = get_weather_temp(weather, year, month, day, hour, minute)
			wind_range = get_weather_wind(weather, year, month, day, hour, minute)
		
			temp_s = "Temperatur-" + (hour<6||hour>18 ? "Nacht" : "Tages") +"verlauf: Zwischen %.1f und %.1f Grad Celsius." % [temp_range[0], temp_range[1]]
			type_s = get_weather_name(weather) + "."

			text = "Wetter: %s %s" % [type_s, temp_s]

			randfun = randomfunny()

			if randfun != nil
				text += " " + randfun
			end

			if temp_range[0] > 0 && (precip >= 16 && precip < 2048) && rand(2) == 0
				text += " Adequates Zuhausebleib-Wetter."
			elsif temp_range[0] <= 0 && rand(2) == 0
				text += " Brrrrr."
			elsif temp_range[0] > 20 && temp_range[1] > 30 && (hour>6||hour<18) && rand(2) == 0 && (hour>6||hour<18)
				text += " Sonnenschutz empfohlen!"
			elsif temp_range[0] > 15 && temp_range[1] <= 30 && 0 == rand(3)
				text += " Die Elfen zwitschern in den Baeumen."
			end
		end

		
		preset = case precip
			when P_HSNOW
				:hsnow
			when P_FOG
				:fog
			when P_DOWNPOUR
				:downpour
			else
				:default
		end

		fog_sun_amount = fogdata[preset][:sun_amount]
		fog_moon_amount = fogdata[preset][:moon_amount]
		fog_sun_color = fogdata[preset][:sun_colour]
		fog_moon_color = fogdata[preset][:moon_colour]
		
		temp_range = [0,0,0,0] if !temp_range
		wind_range = [0,0,0,0] if !wind_range
		
		season = get_season(year, month, day)	

		w = [season, atype,
			temp_range,
			wind_range, 
			fog_sun_amount, fog_sun_color,
			fog_moon_amount, fog_moon_color,
			precip,
			text.strip
		].flatten
	
		w.map{|f|f.to_s}.join(":")
	end

	def get_season(year, month, day)
		return case month
			when 1..2
				S_WINTER
			when 3..4
				S_SPRING
			when 5..9
				S_SUMMER
			when 10..12
				S_FALL
		end
	end
	
	# Dumps the current weather and the next n days to a table
	def dumpweather
		now = Time.now
		return if now.to_i <= @last_weather_dump + 300
		return if !@year
		@last_weather_dump = now.to_i

		
		hours = [12, 0]
		locs = %w{open north desert}

		f = File.new("/home/silm/public_html/weather.html", "w")
		f.puts("<html><body>")
		f.puts("<h2>Date generated: #{now.to_s}</h2>")

		locs.each do |loc|
			year = @year 
			month = @month
			day = @day 
			days_to_go = 30
			f.puts("<h2>Forecast for the next #{days_to_go} days, location: #{loc}</h2><br/>")
		
			f.puts("<pre>")
			while days_to_go > 0
				hours.each do |mean_hour|
					# print row for this day
					# def get_weather_array(atype, year, month, day, hour, minute)
					w = get_weather_array(loc, year, month, day, mean_hour, 0)
					t = get_weather_temp(w, year, month, day, mean_hour, 0)
					n = get_weather_name(w)

					f.puts "%d.%d.%d, %2d:%2d: %s, %.1f to %.1f deg C\n" % [day,month,year,mean_hour,0,n,t[0],t[1]]
				end
				f.puts("\n")

				day += 1
				if day > 30
					day = 1
					month += 1
				end
				if month > 12
					month = 1
					year += 1
				end
				days_to_go -= 1
			end

			f.puts("</pre>")
			f.puts("<br/><br/>")
		end

		f.puts("</body></html>")
		f.close
	end
end
