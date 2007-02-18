
yjservices = gety("jservices")
service = a[0]

if !service || service.strip == ""
	msg(jid, "Syntax: unregister <service>")
elsif !yjservices[service]
	msg(jid, "This service is not known.")
else
	# unregister
	if !yjservices[service]['subscribe'].index(jid)
		msg(jid, "You are not registered for that service.")
	else
		yjservices[service]['subscribe'].delete jid
		savey "jservices", yjservices
		msg(jid, "You are now UNregistered for service '%s'." % service)
	end
end
