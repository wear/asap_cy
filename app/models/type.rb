# == Schema Information
# Schema version: 20090814063601
#
# Table name: types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  parent_id  :integer(4)
#  order      :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Type < ActiveRecord::Base 
  
  has_and_belongs_to_many :vendors
  
  acts_as_tree 
  
  def vendors_count
    vendors.size
  end
end
