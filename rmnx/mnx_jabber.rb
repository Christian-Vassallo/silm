require 'shellwords'
require 'xmpp4r'
require 'xmpp4r/roster/iq/roster'
require 'xmpp4r/roster/helper/roster'
require 'xmpp4r/vcard/helper/vcard'
require 'yaml'
require 'resolv'
require 'iconv'
require 'socket'

require_gem 'activerecord'


class MnxJabber < RMNX::CommandSpace
	include Jabber
	include RMNX::Config
	#Jabber::debug = true

	class OnlineUser < ActiveRecord::Base
		set_table_name 'online'
	end


	class NWBridge
		def initialize pass
			@password = pass
			@t = Thread.new { _t }
		end

		def cmd(str)
			@socket.puts(str)
		end

		def _t
			loop do
				begin
					@socket = TCPSocket.new('localhost', '5120')
					@socket.puts @password
					begin
						str = @socket.gets
						jnotify("nwbridge", str)
					rescue Exception => e
						next
					end

				rescue Exception => e
					sleep 5
				end
			end
		end
	end


	def h(x)
		@iconv.iconv(x)
	end


	def initialize
		jid = 'silmnotify@swordcoast.net/rmnx'.freeze
		@pass = "banjoo".freeze
		@jid = JID.new(jid)
		@iconv = Iconv.new('utf-8', 'iso-8859-1')
		#sql_connect

		@tailfiles = [
			"/home/silm/nwserver/logs.0/nwserverLog1.txt",
			"/home/silm/run.log",
			"/home/silm/nwserver/logs.0/nwnx2.txt",
			"/home/silm/nwserver/logs.0/nwnx_odbc.txt",
		].freeze

		connect
		@t = Thread.new {_t}
		
		@tail_t = Thread.new {_t_tail}

		@nwbridge = NWBridge.new(
			IO::read("/home/silm/config/nwbridgepass").strip
		)
	end

	#def sql_connect
	#	sql = gety("odbc")
	#	ActiveRecord::Base.establish_connection(sql)
	#end

	def mnx_jabber to, subject, message
		msg(to, message)
	end
	
        def mnx_startup rev
		savey("online", [])
                jnotify('cnotify', "Server startup.")
                jnotify('dnotify', "Server startup (Rev: %s): %s" % [rev, Time.now.to_s])
		File.open("/home/silm/.revision", "w") {|f| f.puts(rev)}
        end

	def mnx_chat acc, char, aid, cid, mode, text = ""
		return if text == ""
		if mode.to_i == 32
		 	if gety("online").reject{|p| p['isdm'] == "false" }.size > 0
				sent = jnotify('dmchaton', "[DM] %s: %s" % [char, text])
			else
				ent = jnotify('dmchatoff', "[DM] %s: %s" % [char, text], 0, true)
				return sent
			end
		end
		return 0
	end

        def mnx_cliententer account, char, aid, cid, isdm, ip, key
		host = ""
		dnsovr = gety("dnsovr", {})
		if dnsovr[ip]
			host = dnsovr[ip]
		else
			begin
				host = Resolv::DNS.new.getname(ip).to_s if ip != ""
			rescue
			end
		end
		savey("online", gety("online") << {
			'account' => account,
			'char' => char,
			'aid' => aid.to_i,
			'cid' => cid.to_i,
			'isdm' => isdm,
			'ip' => ip,
			'host' => host,
			'cdkey' => key,
			'area' => ["", "", ""],
			'logon' => Time.now,
		})
		
		account = h account
		char = h char
                jnotify('cnotify', "%s (%s) joins the game (DM: %s)" % [char, account, isdm], aid.to_i)
		jnotify('dnotify', "enter %s(%s): %s(%s) dm: %s, %s/%s/%s" % [account, aid, char, cid, isdm, ip, host, key], aid.to_i)

		return (host == "" ? ip : host).strip
        end

        def mnx_clientleave account, char, aid, cid
		savey("online", gety("online").reject {|i| i['account'] == account }) 
		account = h account
		char = h char
                jnotify('cnotify', "leave %s(%s): %s(%s)" % [account, aid.to_s, char, cid.to_s], aid.to_i)
                jnotify('dnotify', "leave %s(%s): %s(%s)" % [account, aid.to_s, char, cid.to_s], aid.to_i)
        end

        def mnx_areaenter account, char, aid, cid, resref = "", tag = "", name = ""
		return if resref == ""

		savey("online", gety("online").map {|pl|
			pl['area'] = [resref, tag, name] if pl['account'] == account
			pl
		})
		account = account
		char = char
                jnotify("dareanotify", "area_enter %s: %s (tag: %s)" % [char, name, tag])


		usr = gety("users")

		# all those that now are in this area
		gety("online").reject {|f|
			f['area'][0] != resref
		
		# Now check if those users want notification if someone enters their area
		}.each {|f|

			next if f['aid'].to_i == aid.to_i
			next if f['isdm'] == 'true'

			myjid = get_jid_by_aid f['aid'].to_i
			next if !myjid
			if subscribed?(myjid, "dmyareanotify", false)
				msg(myjid, "[dmyareanotify] %s enters your area." %  char, false)
			end
		}
		""
        end

        def mnx_arealeave account, char, aid, cid
		account = account
		char = char
                #jnotify("area_leave %s(%s): %s(%s)" % [account, aid, char, cid])
        end

	private

	#def log target, message
	#	File::open("logs/" + target + ".log", "a+") {|f|
	#		f.puts(message.strip)
	#end

	def _t_tail
		# Wait for jabber to connect
		sleep 3

		puts "opening server tail .."
		p = IO::popen("tail --lines=0 -F #{@tailfiles.join(" ")} 2>&1")
		while ln = p.gets()
			ln.strip!
			ln.gsub!(/^\[[^\]]+\] /, "")
			ign = gety("nwbridge.ignore", [])
			next if ign.reject {|x| nil != (ln =~ x)}.size != ign.size
			e_log(ln)
			jnotify("nwbridge", "> #{ln}")
		end
		puts "server tail died!"
		jnotify("nwbridge", "server tail died!")
	end

	def msg(tojid, ms)
		[ms].flatten.each do |msg|
			@j.send(Message.new(tojid, h(msg)).set_type(:chat).set_id('1') )
		end
	end
	
	# Sends out notifies to all subscribed users of a certain service or group
	# returns the number of messages sent
        def jnotify(service, msg, concernsaccount = 0, donotskip = false)
		i = 0
		msg = "[%s] %s" % [service.downcase, msg]
		if service[0] == ?%
			yjug = gety("usergroups")
			service = service[1..-1]
			return 0 if !yjug[service]
			yjug[service].each do |to|
				next if !donotskip && concernsaccount > 0 &&
					!get_setting(to, "receive_concerning_self") &&
					has_account?(to, concernsaccount)
				
				next if !donotskip && !get_setting(to, "receive_while_ingame") &&
					jid_ingame?(to)

				i += 1
				msg(to, msg)
			end
		else
			yjservices = gety("jservices")
			return 0 if !yjservices[service]
			yjservices[service]['subscribe'].each do |to|
				next if !donotskip && concernsaccount > 0 &&
					!get_setting(to, "receive_concerning_self") &&
					has_account?(to, concernsaccount)
				
				next if !donotskip && !get_setting(to, "receive_while_ingame") &&
					jid_ingame?(to)

				i += 1
				msg(to, msg)
			end
		end
                i
        end

	def subscribed?(jid, service, send_message = true)
		s = gety("jservices")
		if !s[service] || !s[service]['subscribe'].index(jid)
			msg(jid, "You are not subscribed to service '%s'." % service) if send_message
			return false
		else
			return true
		end
	end

	def access?(jid, xaccess)
		return false if !xaccess
		return true if xaccess.size == 0
		access = xaccess.dup 
		access << "%admins" 
		yjservices = gety("jservices")
		yusergroups = gety("usergroups")
		yusers = gety("users")
		subscribed_services = yjservices.keys.reject {|s| yjservices[s]['subscribe'].index(jid) == nil}
		access.each do |a|
			return true if a[0] == ?% && yusergroups[a[1..-1]] && yusergroups[a[1..-1]].index(jid) != nil
			return true if a[0] != ?% && (subscribed_services & [a].flatten).size > 0
		end
		return false
	end

	def has_account?(jid, aid)
		return false if aid == 0 || !aid
		u = gety("users")
		return false if !u[jid]
		return false if !u[jid]['accounts']
		return u[jid]['accounts'].index(aid) != nil
	end

	def account_ingame?(account)
		o = gety("online")
		return o.map {|f| f['aid'].to_i }.index(account.to_i)
	end

	def get_jid_by_aid(aid)
		u = gety("users")
		u.each do |jid, usr|
			return jid if usr['accounts'].index(aid)
		end
		nil
	end
	
	def jid_ingame?(jid)
		o = gety("online")
		aids = gety("users")
		return false if !aids[jid]
		aids = aids[jid]['accounts']
		return false if !aids
		return (o.map {|f| f['aid'].to_i } & aids).size > 0
	end

	DEFAULT_SETTINGS = {
		'receive_while_ingame' => false,
		'receive_while_offline' => true,
		'receive_concerning_self' => false,
	}

	def get_setting(jid, var)
		u = gety("users")
		v = var.downcase
		return DEFAULT_SETTINGS[v] if !u[jid]
		return DEFAULT_SETTINGS[v] if !u[jid]['settings']
		return u[jid]['settings'][v] || DEFAULT_SETTINGS[v]
	end
	def set_setting(jid, var, val)
		u = gety("users")
		v = var.downcase
		u[jid] = {} if !u[jid]
		u[jid]['settings'] = {} if !u[jid]['settings']
		u[jid]['settings'][v] = val
		savey("users", u)
	end

	###########
	# events below
	

	def e_log(line)
		if line.strip =~ /^NWNX2lib: Server exiting\. Kill me now.$/
			pid = `pidof -s nwserver`.strip.to_i
			return if pid == 0
			jnotify("nwbridge", "e_log(): Killing server, because it wont bugger off.")
			jnotify("nwbridge", "   system(\"kill -9 #{pid}\")") 
			system("kill -9 #{pid}") 
		end
	end

	
	def on_service(service, parameters)
		s = gety("jservices")
		
	end

	def j_message m
		f = m.from
		fs = m.from.strip.to_s.downcase
		jid = fs
		yjcommands = gety("jcommands")
		yjservices = gety("jservices")

		a = (m.body || "").split /\s+/
		cmd = a[0].downcase
		a = a[1 .. -1]

		all_services = yjservices.keys
		subscribed_services = yjservices.keys.reject {|s| yjservices[s]['subscribe'].index(jid) == nil}

		if !yjcommands[cmd]
			cmdf = nil
			yjcommands.each do |c, v|
				if v['aliases'] && v['aliases'].index(cmd) != nil
					cmdf = c
					break
				end
			end
			if cmdf.nil?
				msg(f, "Unknown command '%s'." % cmd)
				return
			else
				cmd = cmdf
			end
		end

		if !access?(jid, yjcommands[cmd]['access'])
			msg(f, "You are not subscribed for command '%s' (required: %s)." % [cmd, yjcommands[cmd]['access'].join(' or ')])
			return
		end
		command = yjcommands[cmd]

		case command['type']
			when "internal"
				method('cmd_' + cmd).call(fs, command, a)
			when "external"
				file = 'jcmd_%s.rb' % cmd
				return if !File.exists?(file)
				data = IO.read(file)
				begin
					eval(data)
				rescue Exception => e
					puts e.to_s
					puts e.backtrace.join("\n")
				end
			else
				# ..?
		end
		
	end

	def cmd_help jid, command, a
		ret = ""
		ret << IO.read("jabber.help.txt").strip
		ret << IO.read("jabber.help.dm.txt").strip if access?(jid, %w{dms})
		ret << IO.read("jabber.help.admin.txt").strip if access?(jid, %w{%admins})
		msg(jid, ret)
	end

	def cmd_status jid, command, a
		yjservices = gety("jservices")
		msg(jid, "Server is online since: #{File.stat("/home/silm/nwserver/currentgame.0/").atime}\n \
RMNX backend is online since: #{self.rmnx.startup}\n \
Players currently online: #{gety('online').size}\n \
You are registered for the following services: #{yjservices.keys.reject {|key| !yjservices[key]['subscribe'].index(jid)}.join(', ')}")
	end

	# un/silence
	def cmd_silence jid, command, a
		yu = gety("users")
		if !yu[jid]
			msg(jid, "No user record!")
		else
			set = get_setting(jid, "silent")
			set = set ? false : true
			set_setting(jid, "silent", set)
			msg(jid, set ? "No more messages." : "Messages away!")
		end
	end

	def cmd_service jid, command, a
		yjservices = gety("jservices")
		service = (a[1] || "").downcase

		case (a[0] || "").downcase
			when ""
				serv = []
				yjservices.each do |n, v|
					serv << "  %s (Access user groups: %s)" % [n, (v['access'].size == 0 ? ['everyone'] : v['access']).join(', ')]
					serv << "   Description: %s" % v['description']
				end
				msg(jid, "Services available (not necessarily to you):\n#{serv.join("\n")}")
				msg(jid, " Use 'service register xx' to register to a service.\n User 'service unregister xx' to unregister.")

			when "register", "unregister"
				if !yjservices[service] || !access?(jid, yjservices[service]['access'])
					msg(jid, "This service is not known or not available to you.")
				else
					if "register" == (a[0] || "").downcase
						# register
						if yjservices[service]['subscribe'].index(jid)
							msg(jid, "You are already registered for that service.")
						else
							yjservices[service]['subscribe'] << jid
							savey "jservices", yjservices
							msg(jid, "You are now registered for service '%s'." % service)
						end
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
				end
			else
				msg(jid, "Unknown subcommand '%s' for '%s' Type 'services' to get help." % [a[0], 'services'])
		end
	end

	def cmd_n jid, command, a
		all = a.join(" ")
		@nwbridge.cmd(all)
	end

	def j_roster_sub_req item, presence
		puts "Rq from #{presence.from}: #{presence.type}"
		case presence.type
			when :subscribe
				if access?(presence.from, ['%admin', 'dms'])
					@r.accept_subscription(presence.from)
					msg(presence.from, "Welcome, #{presence.from.to_s}!")
				else
					@r.accept_subscription(presence.from)
					msg(presence.from, "Welcome, #{presence.from.to_s}!")
					#@r.decline_subscription(presence.from)
					#msg(presence.from, "If you need to subscribe to my services, send me 'help'.")
				end
			when :unsubscribe
			when :subscribed
			when :unsubscribed
				
		end
	end
	
	def j_roster_presence item,oldpres,pres
		p item
		p oldpres
		p pres
	end

	def j_roster_update olditem, item
	end

	def connect
		if !@j
			puts "Creating Jabber Object."
			@j = Client.new(@jid)
			@j.on_exception {|e, stream, symbol|
				puts "exception at #{symbol}: #{e.to_s}"
				puts e.backtrace.join("\n")
				connect
			}

			puts "Adding message hooks"
			@j.add_message_callback &method(:j_message)
		end

		if !@j.is_connected?
			puts "Re|Connecting to the durned jabberd"

			@j.connect('127.0.0.1')
			@j.auth(@pass)
			@j.send(Presence.new.set_show(:dnd).set_status('Lurking.').set_priority(100))
			
			@r = Roster::Helper.new(@j)
			puts "Adding roster hooks"
			@r.add_subscription_callback(0, nil, &method(:j_roster_sub_req))
			@r.add_subscription_request_callback(0, nil, &method(:j_roster_sub_req))
		end
		@j
	end

	def _t
		loop do
			@j.process
			sleep 0.5
		end
	end
end
