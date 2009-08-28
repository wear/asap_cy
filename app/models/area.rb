# == Schema Information
# Schema version: 20090814063601
#
# Table name: areas
#
#  id            :integer(4)      not null, primary key
#  parent_id     :integer(4)
#  name          :string(255)
#  order         :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  vendors_count :integer(4)      default(0)
#

class Area < ActiveRecord::Base
  acts_as_tree
  has_many :vendors
  
end
