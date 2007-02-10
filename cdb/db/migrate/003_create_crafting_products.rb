class CreateCraftingProducts < ActiveRecord::Migration
  def self.up
    create_table :crafting_products do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :crafting_products
  end
end
