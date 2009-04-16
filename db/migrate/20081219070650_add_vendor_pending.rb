class AddVendorPending < ActiveRecord::Migration
  def self.up
    add_column :vendors, :pending, :boolean, :default => true
    add_column :merchants, :pending, :boolean, :default => true
  end

  def self.down
    remove_column :merchants, :pending
    remove_column :vendors, :pending
  end
end
