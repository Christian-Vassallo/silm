yjservices = gety("jservices")
service = a[0]

regwho = jid.downcase

if a[1] && access?(jid, ['%admins'])
	regwho = a[1].downcase
end

if !service || service.strip == ""
	msg(jid, "Syntax: register <service>")
elsif !yjservices[service] || !access?(jid, yjservices[service]['access'])
	msg(jid, "This service is not known or not available to you.")
else
	# register
	if yjservices[service]['subscribe'].index(regwho)
		msg(jid, "%s is already registered for that service." % regwho)
	else
		yjservices[service]['subscribe'] << regwho
		savey "jservices", yjservices
		msg(jid, "%s is now registered for service '%s'." % [regwho, service])
		if a[1] # regwho.downcase != jid.downcase
			msg(regwho, "%s registered you for service '%s'." % [jid, service])
		end
		jnotify("%admins", "%s registered %s for %s" % [jid, regwho, service])
	end
end
