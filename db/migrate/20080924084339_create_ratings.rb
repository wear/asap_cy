class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :vendor_id
      t.integer :user_id
      t.integer :score, :default => 0 
      t.integer :vote_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
