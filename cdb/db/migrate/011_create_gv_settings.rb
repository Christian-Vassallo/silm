class CreateGVSettings < ActiveRecord::Migration
  def self.up
    create_table :gv_settings do |t|
    end
  end

  def self.down
    drop_table :gv_settings
  end
end
