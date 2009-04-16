class CreateBookings < ActiveRecord::Migration
  def self.up
    create_table :bookings do |t|
      t.references :user
      t.references :vendor
      t.references :discount

      t.timestamps
    end
  end

  def self.down
    drop_table :bookings
  end
end
