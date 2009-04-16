class MobileUsersBookings < ActiveRecord::Migration
  def self.up
    create_table 'bookings_mobile_users', :id => false do |t|
      t.integer :mobile_user_id
      t.integer :booking_id
    end
  end

  def self.down
    drop_table 'bookings_mobile_users'
  end
end
