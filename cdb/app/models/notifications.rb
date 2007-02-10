class Notifications < ActionMailer::Base
	FROM_MAIL = 'elven@swordcoast.net'

	def comment(comment, to)
		@subject    = 'Silbermarken: Kommentar: ' + comment.character.character
		@body       = {:comment => comment}
		@recipients = [to].flatten.map {|r| r.email}.reject{|n| n == ""}
		@from       = FROM_MAIL
		@sent_on    = Time.now
		@headers    = {}
	end

	def register(character, to)
		@subject    = 'Silbermarken: Neue Anmeldung: ' + character.character
		@body       = {:character => character}
		@recipients = [to].flatten.map {|r| r.email}.reject{|n| n == ""}
		@from       = FROM_MAIL
		@sent_on    = Time.now
		@headers    = {}
	end

	def status(character, to)
		@subject    = 'Silbermarken: Status-Aenderung eines Charakters'
		@body       = {:character => character}
		@recipients = [to].flatten.map {|r| r.email}.reject{|n| n == ""}
		@from       = FROM_MAIL
		@sent_on    = Time.now
		@headers    = {}
	end
end
