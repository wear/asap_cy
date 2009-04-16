class FixUserAndDiscount < ActiveRecord::Migration
  def self.up
    remove_column :users, :mobile
    add_column :users, :mobile, :string
    remove_column :discounts, :status
    add_column :discounts, :status, :string
  end

  def self.down
    remove_column :discounts, :status
    add_column :discounts, :status, :string
    remove_column :users, :mobile
    add_column :users, :mobile, :integer
  end
end
