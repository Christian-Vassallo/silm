class Comment < ActiveRecord::Base
	#belongs_to :account, :foreign_key => "id"
	#belongs_to :character, :foreign_key => "id"

	attr_accessible :status, :body, :account, :character

	def validate
		errors.add(:body, "ist zu lang") if body.size > 100000
		errors.add(:body, "ist zu kurz") if body.strip.size == 0
	end

	def public?
		status == "public"
	end

	def system?
		status == "system"
	end

	def private?
		status == "private"
	end

	def account
		Account.find(super)
	end

	def character
		Character.find(super)
	end
end
