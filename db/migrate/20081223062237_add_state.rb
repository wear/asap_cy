class AddState < ActiveRecord::Migration
  def self.up
    remove_column :bookings, :run
    add_column :bookings, :status, :string
  end

  def self.down
    remove_column :bookings, :status
    add_column :bookings, :run, :boolean,              :default => false
  end
end
