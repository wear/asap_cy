# == Schema Information
# Schema version: 20090814063601
#
# Table name: cards
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  point      :integer(4)
#  desc       :text
#  created_at :datetime
#  updated_at :datetime
#

class Card < ActiveRecord::Base
  has_many :points, :as => 'charge'
  has_one :attachment, :as => "attachable" 
  
  has_one :attachment, :as => 'attachable'
  
  validates_length_of :name, :within => 3..100
  validates_numericality_of :point
  validates_presence_of :desc
  before_save :generate_point
   
  
  def generate_point
    self.point = -(point.abs)
  end
  
  def uploaded_data=(data)
    if attachment
      attachment.update_attributes :uploaded_data => data
    else
      self.attachment = Attachment.create :uploaded_data => data
    end
  end
  
  def images_exists?
    return false unless attachment
    
    File.exists? "public/#{attachment.public_filename}"
  end 
  
  
  
end
