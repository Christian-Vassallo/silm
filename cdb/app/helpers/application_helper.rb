# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def link_to_product p, short = false
		t = link_to((p.name.nil? ? "<i>Unbenutzer Eintrag!</i>" : p.name), :controller => 'craft', :action => 'show', :id => p.id)
		t += " </b>(%d/%d/%s)" % [p.cskill_min, p.cskill_max, p.checks_s] if !short
		t += " <b>%.2f</b>" % [p.practical_xp_factor] if p.practical_xp_factor.to_f != 1.0
		t += " <span id='craft_prod_mag'>(m)</span>" if p.spell != -1
		t += " <span id='craft_prod_script'>(%s)</span>" % [p.s_craft] if p.s_craft != ""
		t
	end

	def link_to_character(c, short = false)
		return "Character not found" if c.nil?
		t = link_to((case c.status
			when "new"
				"<i>" + c.character + "</i>"
			when /^register/
				"<b>" + c.character + "</b>"
			when "ban"
				"<strike>" + c.character + "</strike>"
			else
				c.character
			end), {:controller => "character", :action => "show", :id => c.id }
		)
		t += " <u>#{c.class1_level + c.class2_level + c.class3_level}</u>" if !short
	
		if !short
			cx = c.comments.reject {|n| !session[:user].char_view? && !n.public? }.reject {|n| n.system? }
			t += " (#{cx.size} comment" + (cx.size > 1 ? "s" : "") + ")" if cx.size > 0
			
			t += " <a id='online'>Online!</a>" if c.online?
		end
		
		
		if session[:user] && session[:user].char_view?
			if !short
				t += "<br>  >"
			end
			if !short
				t += " "
				t += c.account.nil? ? "<i>Stray character, no such account_id!</i>" :
					link_to(c.account.account, :controller => 'character', :action => 'index', :search => c.account.account)
			end
			t += " " + link_to("?", :controller => "account", :action => "show", :id => c.account.id) if c.account
			if !short
				t += ""
				t += " <a id='dm'>DM!</a>" if c.dm?
			end
		end
		

		t
	end

	def link_to_account(a)
		link_to (a.display_name != "" ? a.display_name : a.account), :controller => 'account', :action => 'show', :id => a.id
	end


	def strftime(otime)
		otime.strftime(session[:user].nil? || session[:user].strftime == "" ? "%c" : session[:user].strftime)
	end

	def fmt(t, tex = false)
		!tex ? simple_format(sanitize(t)) : textilize(t)
	end
	
end
