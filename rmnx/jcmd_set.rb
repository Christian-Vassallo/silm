
var = (a[0] || "").downcase
val = a[1] || ""

r = []

if var == "" || val == ""
	r << "Your current setting values:"
	#list
	DEFAULT_SETTINGS.keys.each do |key|
		r << "%s: %s" % [key, get_setting(jid, key)]
	end
end

if val != ""
	if !DEFAULT_SETTINGS.keys.index(var)
		r << "No setting named '%s' found." % var
	else
		val = !(val == "0" || val =~ /^f/ || val =~ /^n/)
		set_setting(jid, var, val)
		r << "set #{var} to #{val.to_s}."
	end
end

msg(jid, r.join("\n"))
