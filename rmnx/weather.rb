require 'yaml'
require 'rubygems'
require_gem 'activerecord'


@textkeys = YAML.load(File.new("db.weather.text", "r"))

ActiveRecord::Base.establish_connection(YAML.load(File.new("db.odbc", "r")))

class Weather < ActiveRecord::Base
	set_table_name 'weather'
end

# Weather.()

def d20; rand(20)+1; end
def d6; rand(6)+1; end


class Hash
	def value_in_range_set(v)
		self.each do |key, val|
			if (key.is_a?(Range) && key.to_a.index(v)) ||
				(key.is_a?(Fixnum) && key == v)
				return val
			end
		end
		return self.default
	end
end

WEATHER = {
# Spaeter Winter
# Scheisskalt, relativ viel Schneesturm. Auraun gefriert.
1..2 => {

},

# Frueher Fruehling
#  Viel Regen, gelegentlicher Hagel
3..4 => {

},

# Spaeter Fruehling
# Viel Regen, erste Hitzewellen, erste Muecken
5..6 => {

},

# Frueher Sommer
# Viel Muecken, gelegentlicher Regen, viele Gewitter, Muecken schon erwaehnt?
5..6 => {
	1..6   => {:name => 'Sonnenschein', :variance => 0},
	7..8   => {:name => 'Bewoelkt, gelegentliche Schauer', :variance => -3},
	9..12  => {:name => 'Leichter Morgennebel', :variance => -1},
	13..15 => {:name => 'Nebel', :variance => -2},
	16..17 => {:name => 'Nieselregen', :variance => -2},
	18..19 => {:name => 'Dauerregen', :variance => -4},
	20     => {:name => 'Gewitter', :variance => +2},

},

# Spaeter Sommer
# Muecken an Hitzetod gestorben.
7..8 => {
	1..6   => {:name => 'Sonnenschein', :variance => 0},
	7..8   => {:name => 'Bewoelkt, gelegentliche Schauer', :variance => -3},
	9..12  => {:name => 'Leichter Morgennebel', :variance => -1},
	13..15 => {:name => 'Nebel', :variance => -2},
	16..17 => {:name => 'Nieselregen', :variance => -2},
	18..19 => {:name => 'Dauerregen', :variance => -4},
	20     => {:name => 'Gewitter', :variance => +2},

},

# Herbst
# Erste Blaetter fallen, oben schwarz (verbrannt) unten gruen
# Erster Schnee faellt!
9..10 => {

},

# Frueher Winter
# Durchgehend liegt Schnee
# milde Zeiten, wenig Schneestuerme
11..12 => {
	1..6   => {:name => 'Sonnenschein/Frost, kein Niederschlag', :variance => -3},
	7..12  => {:name => 'Gelegentlicher Schneefall', :variance => -1},
	13..15 => {:name => 'Schneefall', :variance => -2},
	16..17 => {:name => 'Starke Schneewirbel', :variance => -2},
	18..19 => {:name => 'Eisregen. Die Frisur sitzt.', :variance => -1},
	20     => {:name => 'Schneesturm (>40mph)', :variance => +2},
},

}

#YAML.dump(WEATHER, File.new("weather.data", "w"))
 
year_start = 1460
year_end = 1462
month_start = 1
month_end = 12
day_start = 1
day_end = 30
hour_start = 0
hour_end = 23
total = (year_end - year_start) * (month_end - month_start) * (day_end - day_start) * (hour_end - hour_start)


srand(1)

fudge = 0
weather = d20
windex = 8
puts "Starting Weather: #{weather}"
puts "start year: #{year_start}"
puts "end year: #{year_end}"
puts "total records: #{total}"

for year in year_start..year_end do
	
for month in 1..12 do


for day in 1..30 do
	
	print "#{day}.#{month}.#{year} "

	for hour in 0..23 do
		print "."
		wx = WEATHER.value_in_range_set(windex).value_in_range_set(weather)
		wstr = wx[:name]
		wvar = wx[:variance]
		wlast = weather
		
		weather += ( fudge + wvar ) + d6
		weather = 1 if weather > 20
		weather = 1 if weather <= 0
	

		fogv     = 0
		fogc     = 0
		engine   = 'clear'
		textkey  = 1

		thishour = {
			:year => year,
			:month => month,
			:day => day,
			:hour => hour,
			:textkey => textkey,
			:fogv => fogv,
			:fogc => fogc,
			:engine => engine,
		}
		Weather.new(thishour).save
	end
	
	print "\n"

end #days

end #month

end #year
