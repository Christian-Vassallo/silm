class CraftingStatistic < ActiveRecord::Base
	set_table_name "craft_stat"

	belongs_to :character, :foreign_key => "id"
	#belongs_to :recipe, :foreign_key => "id", :class_name => "CraftingProduct"
	
	def recipe
		begin
			CraftingProduct.find(super)
		rescue
			nil
		end
	end
end
