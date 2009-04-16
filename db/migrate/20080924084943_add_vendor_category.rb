class AddVendorCategory < ActiveRecord::Migration
  def self.up
    add_column :vendors, :category_id, :integer
  end

  def self.down
    remove_column :vendors, :category_id
  end
end
