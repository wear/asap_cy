class CreateScoreSumaries < ActiveRecord::Migration
  def self.up
    create_table :score_sumaries do |t|
      t.integer :vote_id
      t.float :score, :default => 0
      t.integer :vendor_id

      t.timestamps
    end
  end

  def self.down
    drop_table :score_sumaries
  end
end
