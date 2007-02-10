class CreateMerchantInventories < ActiveRecord::Migration
  def self.up
    create_table :merchant_inventories do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :merchant_inventories
  end
end
