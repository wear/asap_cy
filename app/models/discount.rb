# == Schema Information
# Schema version: 20081223080043
#
# Table name: discounts
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  count       :float
#  created_at  :datetime
#  updated_at  :datetime
#  description :string(255)
#  start_date  :date
#  stop_date   :date
#  start_at    :time
#  stop_at     :time
#  name        :string(255)
#  version     :integer(4)      default(1)
#  status      :string(255)
#

class Discount < ActiveRecord::Base
  has_many :vendors
  
  belongs_to :user
  has_many :bookings
  has_one :attachment, :as => 'attachable'      
  validates_numericality_of :count
  validates_inclusion_of :count, :in => 0.1..10
  validates_length_of :name, :within => 3..80 
  
  version_fu 
  acts_as_state_machine :initial => :unused, :column => 'status'
  
  state :unused 
  # need to send a sms message to user
  state :used
  state :closed
  
  event :use do
    transitions :to => :used, :from => :unused
  end

  event :close do
    transitions :to => :closed, :from => :used
  end
        
    
  def ad
    self.attachment.public_filename
  end 
  
  def ad_data=(data)
    if attachment
      attachment.update_attributes :uploaded_data => data
    else
      self.attachment = Attachment.create :uploaded_data => data
    end
  end
  
end       

