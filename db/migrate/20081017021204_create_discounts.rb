class CreateDiscounts < ActiveRecord::Migration
  def self.up
    create_table :discounts do |t|
      t.references :user
      t.float :count
      t.references :vendor
      t.datetime :start_at
      t.datetime :stop_at

      t.timestamps
    end
  end

  def self.down
    drop_table :discounts
  end
end
