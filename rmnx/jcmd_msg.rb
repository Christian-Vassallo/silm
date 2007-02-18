jyservices = gety("jservices")
yug = gety("usergroups")

msgto = [(a[0] || "").split(",")].compact.flatten
msg = "#{jid} says: " + a[1..-1].join(" ").strip

ret = []
all = 0
msgto.each do |x|
	all += jnotify(x, msg, 0, true)
end
ret << "Message sent to %d users." % all

msg(jid, ret.join("\n"))
