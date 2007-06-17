class ChessGame < ActiveRecord::Base

	def white
		Account::find(super)
	end

	def black
		Account::find(super)
	end

	# Returns the winner
	def winner
		if result == 'white'
			return white
		elsif result == 'black'
			return black
		end
		nil
	end
end
