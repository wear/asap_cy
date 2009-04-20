class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.string :name
      t.integer :category_id
      t.integer :spec
      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
