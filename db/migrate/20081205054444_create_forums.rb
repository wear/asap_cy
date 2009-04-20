class CreateForums < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.string :name
      t.string :description
      t.integer :parent_id
      t.integer :order

      t.timestamps
    end
  end

  def self.down
    drop_table :forums
  end
end
