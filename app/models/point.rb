# == Schema Information
# Schema version: 20081031081802
#
# Table name: points
#
#  id          :integer(11)     not null, primary key
#  user_id     :integer(11)
#  score       :integer(11)
#  charge_id   :integer(11)
#  charge_type :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Point < ActiveRecord::Base
  belongs_to :user
  
  belongs_to :charge, :polymorphic => true
  
  validates_numericality_of :score
  
  named_scope :card_count, :conditions => { :charge => Card }
  
  class << self
    def purcharse(charge,user)
      if user.points_count > charge.point.abs
        Point.create(:user => user, :charge => charge, :score => charge.point )
      end 
    end
  end 
      
end
