class AddDiscountName < ActiveRecord::Migration
  def self.up
    add_column :discounts, :name, :string
  end

  def self.down
    remove_column :discounts, :name
  end
end
