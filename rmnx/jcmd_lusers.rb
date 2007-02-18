jyservices = gety("jservices")
yug = gety("usergroups")

#subscribed_services = yjservices.keys.reject {|s| yjservices[s]['subscribe'].index(jid) == nil}

ret = []
yug.each do |u, a|
	ret << "%#{u}: #{a.join(', ')}"
end
jyservices.each do |service, data|
	ret << "#{service}: #{data['subscribe'].join(', ')}"
end
msg(jid, ret.join("\n"))
