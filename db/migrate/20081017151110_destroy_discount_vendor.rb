class DestroyDiscountVendor < ActiveRecord::Migration
  def self.up  
    remove_column :discounts, :vendor_id
  end

  def self.down
    add_column :discounts, :vendor_id, :integer,   :limit => 11
  end
end
