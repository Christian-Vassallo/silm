require 'rubygems'
require_gem 'activerecord'

class Location < ActiveRecord::Base; end

class LocationService < RMNX::CommandSpace
	include RMNX::Config

	def initialize
		sql_connect
	end

	def sql_connect
		sql = gety("odbc")
		ActiveRecord::Base.establish_connection(sql)
		ActiveRecord::Base.table_name_prefix = "nwserver."
		ActiveRecord::Base.connection.execute 'set client_encoding = \'iso-8859-15\';';
		# ActiveRecord::Base.connection.instance_eval {@connection.reconnect = true}
	end

	def mnx_location_count a
		r = /#{Regexp.escape(a)}/i
		ids = {}
		online_charnames = gety("online").reject {|x|
			x['cid'] == 0
		}.map {|x|
			ids[x['char']] = x['cid']
			x['char']
		}.reject {|x|
			x !~ r
		}

		matches = Location::find(:all, :conditions => [
			'name like ?', '%' + a + '%'
		]).map {|x| x['name']}

		matches = online_charnames.concat(matches)

		direct = Location::find(:first, :conditions => [
			'name = ?', a
		])

		return "1##{a}" if direct
	
		return "%d#%s" % [matches.size, matches.join(", ")]
	end


	def mnx_location a
		r = /#{Regexp.escape(a)}/i
		ids = {}
		online_charnames = gety("online").map {|x| 
			ids[x['char']] = x['cid']
			x['char']
		}.reject {|x|
			x !~ r
		}
		
		matches = Location::find(:all, :conditions => [
			'name like ?', '%' + a +  '%'
		])


		direct = Location::find(:first, :conditions => [
			'name = ?', a
		])

		if (online_charnames.size + matches.size) != 1 && !direct
			raise "MultiMatchError"
		end

		m = direct || online_charnames[0] || matches[0]
		
		if m.is_a?(String)
			return "p#{ids[m]}"
		else
			return "l" + l2s(m["area"], m["x"], m["y"], m["z"] || 0.0, m["f"] || 1.0)
		end
	end

	private
	def l2s(area_tag, x, y, z, f)
		#            "#A#" + GetTag(oArea) + "#X#" + FloatToString(vPosition.x) +
		#            "#Y#" + FloatToString(vPosition.y) + "#Z#" +
		#            FloatToString(vPosition.z) + "#O#" + FloatToString(fOrientation) + "#E#";
		return "#A#%s#X#%f#Y#%f#Z#%f#O#%f#E#" % [area_tag, x, y, z, f]
	end

end
