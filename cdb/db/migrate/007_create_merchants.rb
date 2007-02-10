class CreateMerchants < ActiveRecord::Migration
  def self.up
    create_table :merchants do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :merchants
  end
end
