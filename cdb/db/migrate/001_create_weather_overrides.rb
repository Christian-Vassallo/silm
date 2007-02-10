class CreateWeatherOverrides < ActiveRecord::Migration
  def self.up
    create_table :weather_overrides do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :weather_overrides
  end
end
