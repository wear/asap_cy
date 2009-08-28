# == Schema Information
# Schema version: 20090814063601
#
# Table name: votes
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  category_id :integer(4)
#  spec        :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  short_name  :string(255)
#

class Vote < ActiveRecord::Base
  belongs_to :category
   
  named_scope :order_by_spec,:order => "spec ASC"     
  named_scope :by_spec, lambda { |*args| {:conditions => [ "spec = ?", args.first]}}
  
end
