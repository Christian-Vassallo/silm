
var = (a[0] || "").downcase
val = a[1] || ""

r = []

if var == "" || val == ""
	r << "Your current setting values:"
	#list
	DEFAULT_SETTINGS.keys.each do |key|
		r << "%s: %s (%s)" % [key, get_setting(jid, key), DEFAULT_SETTINGS[key].class.to_s]
	end
end

if val != ""
	if !DEFAULT_SETTINGS.keys.index(var)
		r << "No setting named '%s' found." % var
	else
		val = case DEFAULT_SETTINGS[var]
			when Fixnum
				val = val.to_i
				set_setting(jid, var, val)
				r << "set #{var} to #{val.to_s}."
			when Float
				val = val.to_f
				set_setting(jid, var, val)
				r << "set #{var} to #{val.to_s}."
			else
				r << "Invalid setting value: #{val}."
		end

	end
end

msg(jid, r.join("\n"))
