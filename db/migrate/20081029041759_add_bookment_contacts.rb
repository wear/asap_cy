class AddBookmentContacts < ActiveRecord::Migration
  def self.up
    remove_column :bookings, :user_id
    remove_column :bookings, :contact
    remove_column :bookings, :email
    remove_column :bookings, :mobile
    add_column :bookings, :bookable_id, :integer
    add_column :bookings, :bookable_type, :string
  end

  def self.down 
    add_column :bookings, :mobile, :string
    add_column :bookings, :email, :string
    add_column :bookings, :contact, :string
    remove_column :bookings, :bookable_type
    remove_column :bookings, :bookable_id
    add_column :bookings, :user_id, :integer
  end
end
