class AddUserMobile < ActiveRecord::Migration
  def self.up
    add_column :users, :mobile, :integer
  end

  def self.down
    remove_column :users, :mobile
  end
end
