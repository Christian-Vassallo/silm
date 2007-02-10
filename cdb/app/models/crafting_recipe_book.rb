class CraftingRecipeBook < ActiveRecord::Base
	set_table_name "craft_rcpbook"
	belongs_to :character

	def craft
		Craft.find(:first, :conditions => ['cskill = ?', cskill])
	end

	def recipe
		CraftingProduct.find(recipe)
	end
end
