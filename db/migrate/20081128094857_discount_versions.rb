class DiscountVersions < ActiveRecord::Migration
  def self.up 
    create_table :discount_versions do |t|
      t.integer :discount_id
      t.integer :version
      t.float   :count
      t.string  :description
      t.date    :start_date
      t.date    :stop_date
      t.time    :start_at
      t.time    :stop_at
      t.string  :name
    end  
    
    add_column :discounts, :version, :integer, :default => 1
  end

  def self.down
    drop_table :discount_versions
    remove_column :discounts, :version
  end
end
