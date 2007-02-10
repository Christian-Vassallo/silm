class CraftingSkill < ActiveRecord::Base
	set_table_name "craft_skill"
	belongs_to :character, :foreign_key => "id"

	def craft
		Craft.find(:first, :conditions => ['cskill = ?', cskill])
	end


end
