module RMNX
	
	module Colour
		CLO  = 40
		CHI = 210

		CRED      = [HI, 0, 0]
		CDARKRED  = [LO, 0, 0]

		CGREEN    = [0, HI, 0]

		CBLUE     = [0, 0, HI]

		def c col, text = nil
			if text.nil?
				"<c%c%c%c>" % col
			else
				"<c%c%c%c>%s</c>" % [col, text].flatten
			end
		end
	end

end
