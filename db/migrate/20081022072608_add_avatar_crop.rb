class AddAvatarCrop < ActiveRecord::Migration
  def self.up
    add_column :users, :avatar_left, :integer
    add_column :users, :avatar_right, :integer
    add_column :users, :avatar_top, :integer
    add_column :users, :avatar_bottom, :integer
  end

  def self.down
    remove_column :users, :avatar_bottom
    remove_column :users, :avatar_top
    remove_column :users, :avatar_right
    remove_column :users, :avatar_left
  end
end
