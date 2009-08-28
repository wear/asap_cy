# == Schema Information
# Schema version: 20090814063601
#
# Table name: contacts
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  email            :string(255)
#  mobile           :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  contactable_id   :integer(4)
#  contactable_type :string(255)
#

class Contact < ActiveRecord::Base 

  belongs_to :contactable, :polymorphic => true    
  
  validates_length_of :name, :within => 3..40
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  
  def validate
    unless self.mobile.to_s.size == 11
      errors.add("mobile", "should be 11 digits")
    end
  end
  
end
