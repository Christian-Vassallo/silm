class CreateMentorDatas < ActiveRecord::Migration
  def self.up
    create_table :mentor_datas do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :mentor_datas
  end
end
