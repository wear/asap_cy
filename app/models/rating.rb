# == Schema Information
# Schema version: 20090814063601
#
# Table name: ratings
#
#  id         :integer(4)      not null, primary key
#  review_id  :integer(4)
#  score      :integer(4)      default(0)
#  vote_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Rating < ActiveRecord::Base
  belongs_to :vendor
  
  named_scope :env,:conditions => ["category = ?",'环境']
  named_scope :taste,:conditions => ["category = ?",'口味']
  named_scope :ser,:conditions => ["category = ?",'服务']  
  named_scope :avg,:conditions => ["category = ?",'人均']
  named_scope :normal,:conditions => ["category != ?",'人均'] 
 
end
