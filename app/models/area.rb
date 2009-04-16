# == Schema Information
# Schema version: 20081223080043
#
# Table name: areas
#
#  id         :integer(4)      not null, primary key
#  parent_id  :integer(4)
#  name       :string(255)
#  order      :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Area < ActiveRecord::Base
  acts_as_tree
  has_many :vendors
  
end
