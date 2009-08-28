# == Schema Information
# Schema version: 20090814063601
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
end 
