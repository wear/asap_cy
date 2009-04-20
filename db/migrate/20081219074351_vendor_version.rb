class VendorVersion < ActiveRecord::Migration
  def self.up
    add_column :vendors, :creator_id, :integer
    add_column :vendors, :author_id, :integer
    add_column :vendors, :version, :integer, :default => 1
  end

  def self.down
    remove_column :vendors, :version
    remove_column :vendors, :author_id
    remove_column :vendors, :creator_id
  end
end
