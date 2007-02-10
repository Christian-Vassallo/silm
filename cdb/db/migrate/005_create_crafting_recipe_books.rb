class CreateCraftingRecipeBooks < ActiveRecord::Migration
  def self.up
    create_table :crafting_recipe_books do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :crafting_recipe_books
  end
end
