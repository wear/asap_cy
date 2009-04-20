class RemoveDiscountOnBookings < ActiveRecord::Migration
  def self.up
    remove_column :bookings, :discount_id
  end

  def self.down
    add_column :bookings, :discount_id, :integer, :limit => 11
  end
end
