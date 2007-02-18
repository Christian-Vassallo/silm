onl = gety("online")
o = []
onl.each do |p|
	o << ("%s (Account: %s) (DM: %s)" % [p['char'], p['account'], p['isdm']])
	o << ("    %s -> %s, %s" % [p['ip'], p['host'], p['key']]) if access?(jid, %w{dms %admins})
	o << ("    %s (%s/%s)" % p['area'].map{|x|x}.reverse ) if access?(jid, %w{dms %admins}) && p['area'].size == 3
end
msg(jid, o.size == 0 ? "Noone online." : "Online players (%d):\n%s" % [onl.size, o.join("\n")])
