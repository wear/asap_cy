class AddMoreBookingColumn < ActiveRecord::Migration
  def self.up
    add_column :bookings, :date, :datetime
    add_column :bookings, :time_range, :integer
    add_column :bookings, :guest_count, :integer
    add_column :bookings, :requirment, :string
    add_column :bookings, :contact, :string
    add_column :bookings, :mobile, :string
    add_column :bookings, :email, :string
    #remove_column :bookings, :user_id
    #add_column :bookings, :userable_id, :integer
    #add_column :bookings, :userable_tye, :string
  end

  def self.down
  #  remove_column :bookings, :userable_tye
  #  remove_column :bookings, :userable_id
  #  add_column :bookings, :user_id, :integer,    :limit => 11
    remove_column :bookings, :email
    remove_column :bookings, :mobile
    remove_column :bookings, :contact
    remove_column :bookings, :requirment
    remove_column :bookings, :guest_count
    remove_column :bookings, :time_range
    remove_column :bookings, :date
  end
end
