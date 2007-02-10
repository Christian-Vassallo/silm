class CreateCraftingStatistics < ActiveRecord::Migration
  def self.up
    create_table :crafting_statistics do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :crafting_statistics
  end
end
