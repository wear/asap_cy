class AddCount < ActiveRecord::Migration
  def self.up
    add_column :areas, :vendors_count, :integer, :default => 0

      Area.reset_column_information
      Area.find(:all).each do |p|
        Area.update_counters p.id, :vendors_count => p.vendors.length
      end
 
  end

  def self.down

    remove_column :areas, :vendors_count
  end
end
