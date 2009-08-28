class MoreMobileItem < ActiveRecord::Migration
  def self.up
    add_column :mobile_users, :status, :string,:default => 'pending'
  end

  def self.down
    remove_column :mobile_users, :status
  end
end
