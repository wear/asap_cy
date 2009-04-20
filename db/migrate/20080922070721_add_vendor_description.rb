class AddVendorDescription < ActiveRecord::Migration
  def self.up
    remove_column :vendors, :telareacode
    remove_column :vendors, :tel
    add_column :vendors, :description, :text
    add_column :vendors, :nearby, :string
    add_column :vendors, :alias, :string
  end

  def self.down
    remove_column :vendors, :alias
    remove_column :vendors, :nearby
    remove_column :vendors, :description
  end
end
