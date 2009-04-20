class AddBookingRun < ActiveRecord::Migration
  def self.up
    add_column :bookings, :run, :boolean, :default => false
    add_column :bookings, :discount_id, :integer
  end

  def self.down
    remove_column :bookings, :discount_id
    remove_column :bookings, :run
  end
end
