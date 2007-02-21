class CreateTimeXPs < ActiveRecord::Migration
  def self.up
    create_table :time_xps do |t|
    end
  end

  def self.down
    drop_table :time_xps
  end
end
