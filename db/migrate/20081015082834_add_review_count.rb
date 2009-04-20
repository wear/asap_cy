class AddReviewCount < ActiveRecord::Migration
  def self.up
    create_table :vendor_versions do |t|
      t.integer :vendor_id, :version, :author_id, :tel1, :area_id, :category_id
      t.string  :name, :address, :nearby, :alias
      t.timestamps
    end
    add_column :vendors, :reviews_count, :integer, :default => 0
    
    Vendor.reset_column_information  
        Vendor.find(:all).each do |p|  
        p.update_attribute :reviews_count, p.reviews.length  
    end
  end

  def self.down
    drop_table :vendor_versions          
    remove_column :vendors, :reviews_count
  end
end
