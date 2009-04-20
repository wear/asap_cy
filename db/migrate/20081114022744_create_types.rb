class CreateTypes < ActiveRecord::Migration
  def self.up
    create_table :types do |t|
      t.string :name
      t.integer :parent_id
      t.integer :order

      t.timestamps
    end
  end

  def self.down
    drop_table :types
  end
end
