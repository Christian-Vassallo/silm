class FaerunianDate
	MONTHNAMES = [nil]+ %w{Hammer Alturiak Ches Tarsakh Mirtul Kythorn Flamerule Elesias Eleint Marpenoth Uktar Nightal}
	MONTHDESCRIPTIONS = [nil, 'Deepwinter', 'The Claw of Winter', 'The Claw of the Sunsets', 'The Claw of the Storms', 'The Melting', 'The Time of Flowers', 'Summertide', 'Highsun', 'The Fading', 'Leaffall', 'The Rotting', 'The Drawing Down']

	HOLIDAYS = {
		30, 'Midwinter',
		4*30, 'Greengrass',
		7*30, 'Midsummer',
		9*30, 'Hightharvest Tide',
		11*30, 'The Feast Of The Moon',
	}

	def self.strftime(fmt, year, month, dom, hour, minute, second)
		doy = month * 30 + dom - 1
		holiday = HOLIDAYS[doy]
		ret = fmt.gsub(
			"%Y", MONTHDESCRIPTIONS[month]
		).gsub(
			"%y", "%d" % year
		).gsub(
			"%M", MONTHNAMES[month] + (holiday ? ", " + holiday : "")
		).gsub(
			"%d", "%d" % dom
		).gsub(
			"%h", "%.2d" % hour
		).gsub(
			"%m", "%.2d" % minute
		).gsub(
			"%s", "%.2d" % second
		)
		ret
	end
		
end

