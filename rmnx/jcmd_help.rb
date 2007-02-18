topic = (a[0] || "").downcase
ret = []

if topic != ""
	if topic =~ /^[a-z]$/ || File::exists?("help.#{topic}")
		ret << IO.read("help.#{topic}").strip
	else
		ret << "No such help topic: #{topic}. Available topics: "
		ret << Dir["help.*"].map {|x| x =~ /^help\.([a-z]+)$/; $1}.join(", ")
		
	end
end
if topic == ""
	yjc = gety("jcommands")
	yjs = gety("jservices")

	ck = yjc.keys.sort {|a,b| yjc[a]['sort'] <=> yjc[b]['sort']}
	sk = yjs.keys.sort {|a,b| yjs[a]['sort'] <=> yjs[b]['sort']}

	ret << ""
	ret << "Available commands: "
	ck.each {|key|
		c, v = key, yjc[key]
		next if !v['description']
		next if v['hidden']
		next if !access?(jid, v['access'])
		ret << "  %s (Access: %s)" % [c, (v['access'].size == 0 ? ['everybody'] : v['access']).join(' or ')]
		ret << "     %s" % v['description']
		ret << "     Aliases: %s" % [v['aliases'].join(' ')] if v['aliases'] && v['aliases'].size>0
	}
	ret << ""
	ret << "Available services: "
	sk.each {|key|
		c, v = key, yjs[key]
		next if !v['description']
		next if v['hidden']
		next if !access?(jid, v['access'])
		ret << "  %s (Access: %s)" % [c, (v['access'].size == 0 ? ['everybody'] : v['access']).join(' or ')]
		ret << "     %s" % v['description'] if v['description']
	}
end
msg(jid, ret.join("\n"))
