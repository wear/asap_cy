class AddVersionBooking < ActiveRecord::Migration
  def self.up
    add_column :bookings, :discount_version, :integer
  end

  def self.down
    remove_column :bookings, :discount_version
  end
end
