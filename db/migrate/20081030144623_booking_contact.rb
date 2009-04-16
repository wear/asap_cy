class BookingContact < ActiveRecord::Migration
  def self.up
    add_column :bookings, :contact, :string
    add_column :bookings, :email, :string
    add_column :bookings, :mobile, :string
  end

  def self.down
    remove_column :bookings, :mobile
    remove_column :bookings, :email
    remove_column :bookings, :contact
  end
end
