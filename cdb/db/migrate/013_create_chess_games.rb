class CreateChessGames < ActiveRecord::Migration
  def self.up
    create_table :chess_games do |t|
      t.column :start, :datetime
      t.column :end, :datetime
      t.column :white, :int
      t.column :black, :int
      t.column :result, :enum
    end
  end

  def self.down
    drop_table :chess_games
  end
end
