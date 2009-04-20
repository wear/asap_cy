class AddDiscountStatus < ActiveRecord::Migration
  def self.up 
    add_column :discounts, :status, :boolean, :default => true
  end

  def self.down
    remove_column :discounts, :status
  end
end
