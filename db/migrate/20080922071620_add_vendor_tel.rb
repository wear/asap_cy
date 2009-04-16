class AddVendorTel < ActiveRecord::Migration
  def self.up
    add_column :vendors, :tel1, :integer
    add_column :vendors, :tel2, :integer
    add_column :vendors, :area_id, :integer
  end

  def self.down
    remove_column :vendors, :area_id
    remove_column :vendors, :tel2
    remove_column :vendors, :tel1
  end
end
