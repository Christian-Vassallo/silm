class CreateGemChains < ActiveRecord::Migration
  def self.up
    create_table :gem_chains do |t|
    end
  end

  def self.down
    drop_table :gem_chains
  end
end
