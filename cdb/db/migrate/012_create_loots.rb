class CreateLoots < ActiveRecord::Migration
  def self.up
    create_table :loots do |t|
    end
  end

  def self.down
    drop_table :loots
  end
end
