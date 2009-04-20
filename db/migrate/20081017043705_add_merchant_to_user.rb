class AddMerchantToUser < ActiveRecord::Migration
  def self.up                          
    add_column :users, :merchant_id, :integer
    remove_column :merchants, :user_id
  end                                  

  def self.down
    add_column :merchants, :user_id, :integer,    :limit => 11
    remove_column :users, :merchant_id
  end
end
