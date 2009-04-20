# == Schema Information
# Schema version: 20081223080043
#
# Table name: mobile_users
#
#  id         :integer(4)      not null, primary key
#  mobile     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MobileUser < ActiveRecord::Base
  has_many :bookings, :as => 'bookable'           
  has_many :contacts, :as => "contactable"
  
  validates_numericality_of :mobile
  validates_format_of :mobile, :with => /^13[0-9]|^15[0-9][0-9]{8}$/

  
  def validate
    unless self.mobile.to_s.size == 11
      errors.add("mobile", "should be 11 digits")
    end
  end  
  
end
