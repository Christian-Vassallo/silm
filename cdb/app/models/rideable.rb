class Rideable < ActiveRecord::Base
	attr_protected :pay_rent

	def Rideable.inheritance_column
		return "inherit_type"
	end
end
