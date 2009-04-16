class ChangeDiscountDate < ActiveRecord::Migration
  def self.up
    remove_column :discounts, :stop_at
    remove_column :discounts, :start_at
    add_column :discounts, :start_date, :date
    add_column :discounts, :stop_date, :date
    add_column :discounts, :start_at, :time
    add_column :discounts, :stop_at, :time
  end

  def self.down
    remove_column :discounts, :stop_at
    remove_column :discounts, :start_at
    remove_column :discounts, :stop_date
    remove_column :discounts, :start_date
    add_column :discounts, :start_at, :datetime
    add_column :discounts, :stop_at, :datetime
  end
end
