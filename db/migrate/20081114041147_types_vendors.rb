class TypesVendors < ActiveRecord::Migration
  def self.up
    create_table 'types_vendors', :id => false do |t|
      t.column :vendor_id, :integer
      t.column :type_id, :integer
    end
    
  end

  def self.down 
     drop_table 'types_vendors'  
  end
end
