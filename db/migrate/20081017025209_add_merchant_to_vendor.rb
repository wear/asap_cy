class AddMerchantToVendor < ActiveRecord::Migration
  def self.up
    add_column :vendors, :merchant_id, :integer
    add_column :vendors, :discount_id, :integer
    add_column :discounts, :description, :string
  end

  def self.down
    remove_column :discounts, :description
    remove_column :vendors, :discount_id
    remove_column :vendors, :merchant_id
  end
end
