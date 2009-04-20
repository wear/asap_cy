# == Schema Information
# Schema version: 20081223080043
#
# Table name: bookings
#
#  id               :integer(4)      not null, primary key
#  vendor_id        :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#  date             :datetime
#  time_range       :integer(4)
#  guest_count      :integer(4)
#  requirment       :string(255)
#  bookable_id      :integer(4)
#  bookable_type    :string(255)
#  contact          :string(255)
#  email            :string(255)
#  mobile           :string(255)
#  discount_id      :integer(4)
#  discount_version :integer(4)
#  status           :string(255)
#

class Booking < ActiveRecord::Base
  belongs_to :vendor

  belongs_to :bookable, :polymorphic => true
   
  belongs_to :discount
  
  has_many :points, :as => 'charge'
  
  named_scope :lastest_create, :order => 'created_at ASC',:limit => 10
  
  validates_presence_of :date
  validates_presence_of :time_range
  validates_numericality_of :guest_count
  
  validates_presence_of     :contact 
  validates_length_of       :contact, :within => 3..20
  
  validates_format_of       :mobile, :with => /^13[0-9]|^15[0-9][0-9]{8}$/ 

  acts_as_state_machine :initial => :pending, :column => 'status'
  
  
  state :pending 
  # need to send a sms message to user
  state :running
  state :closed
  
  event :run do
    transitions :to => :running, :from => :pending
  end

  event :close do
    transitions :to => :closed, :from => :running
  end
  
  
  def validate
    unless self.mobile.to_s.size == 11
      errors.add(:mobile, "should be 11 digits")
    end
  end
  
  
  
end
