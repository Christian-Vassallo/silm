class Chatlog < ActiveRecord::Base
	def character
		id = super
		id == 0 ? nil : Character.find(super)
	end
	def account
		id = super
		id == 0 ? nil : Account.find(super)
	end
end
