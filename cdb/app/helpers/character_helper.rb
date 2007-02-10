module CharacterHelper
	def status2string(status)
		return case status
			when "new"
				"Neu"
			when "register"
				"Anmeldung abgeschickt"
			when "accept"
				"Angemeldet"
			when "ban"
				"Abgelehnt"
			when "invalidate"
				"Invalidate Character"
		end
	end
end
