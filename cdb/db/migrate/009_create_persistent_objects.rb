class CreatePersistentObjects < ActiveRecord::Migration
  def self.up
    create_table :persistent_objects do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :persistent_objects
  end
end
