

jnotify("nwbridge", "#{jid} restarting server ..")
jnotify("%admins", "#{jid} restarting server ..")
jnotify("dms", "#{jid} restarting server ..")

pid = `pidof -s nwserver`.strip
pid = pid.to_i
ret = []
ret << "pid is #{pid}"
ret << "sending now: kill -15 #{pid}"
system("kill -15 #{pid}")
ret << "Now wait for nwserver to shutdown"

#ret << "sending in 5: kill -9 #{pid}"
#system("sleep 6 && kill -9 #{pid} &")

msg(jid, ret.join("\n"))
