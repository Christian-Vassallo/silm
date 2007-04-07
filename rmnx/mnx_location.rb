require 'rubygems'

class Location < RMNX::CommandSpace
	include RMNX::Config

	def initialize
	end

	def mnx_location_count a
		l = gety("locations")
	
		matches = l.reject {|ll|
			ll['name'] !~ /#{Regexp.escape(a)}/
		}

		return "%d#%s" % [matches.size, matches.map{|x| x['name']}.join(", ")]
	end


	def mnx_location a
		l = gety("locations")
		direct = nil
		matches = l.reject {|ll|
			direct = ll if ll['name'] == a
			ll['name'] !~ /#{Regexp.escape(a.downcase)}/
		}

		if matches.size != 1 && !direct
			raise "MultiMatchError"
		end

		m = direct || matches[0]

		return l2s(m["area"], m["x"], m["y"], m["z"] || 0.0, m["f"] || 1.0)
	end

	private
	def l2s(area_tag, x, y, z, f)
		#            "#A#" + GetTag(oArea) + "#X#" + FloatToString(vPosition.x) +
		#            "#Y#" + FloatToString(vPosition.y) + "#Z#" +
		#            FloatToString(vPosition.z) + "#O#" + FloatToString(fOrientation) + "#E#";
		return "#A#%s#X#%f#Y#%f#Z#%f#O#%f#E#" % [area_tag, x, y, z, f]
	end

end
