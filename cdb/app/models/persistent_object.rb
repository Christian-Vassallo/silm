class PersistentObject < ActiveRecord::Base
	set_table_name "placeables"
	
	def first_placed_by
		begin
			Character.find(super)
		rescue
			super
		end
	end
	def last_placed_by
		begin
			Character.find(super)
		rescue
			super
		end
	end
end
