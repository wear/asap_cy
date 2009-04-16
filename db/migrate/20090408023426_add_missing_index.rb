class AddMissingIndex < ActiveRecord::Migration
  def self.up
    add_index "score_sumaries", ["vendor_id",'vote_id'], :name => "score_sumaries_vendor_id_vote_id"
    add_index 'votes',['category_id','spec'],:name =>'votes_category_id_spec'
    add_index 'votes',['short_name'],:name =>'votes_short_name' 
    add_index 'areas',['parent_id'],:name =>'area_parent_id'   
    add_index :vendors, :merchant_id
    add_index :vendors, :discount_id
    add_index :vendors, :area_id
    add_index :vendors, :creator_id
    add_index :types, :parent_id
    add_index :types_vendors, :vendor_id
    add_index :types_vendors, :type_id
  end

  def self.down    
    remove_index :types_vendors, :type_id
    remove_index :types_vendors, :vendor_id
    mind
    remove_index :types, :parent_id
    remove_index :score_sumaries, :name => :score_sumaries_vendor_id_vote_id
    remove_index :areas,:name => :area_parent_id 
    remove_index :vendors, :creator_id
    remove_index :vendors, :discount_id 
    remove_index :vendors, :merchant_id 
   remove_index :vendors, :area_id 
    remove_index  :votes,:name =>:votes_category_id_spec
    remove_index  :votes,:name =>:votes_short_name 
  end
end
