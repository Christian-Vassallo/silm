class CreateChatlogs < ActiveRecord::Migration
  def self.up
    create_table :chatlogs do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :chatlogs
  end
end
