class MoreMobileItem < ActiveRecord::Migration
  def self.up
    add_column :mobiles, :status, :string
  end

  def self.down
    remove_column :mobiles, :status
  end
end
