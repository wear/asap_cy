# == Schema Information
# Schema version: 20090814063601
#
# Table name: attachments
#
#  id              :integer(4)      not null, primary key
#  size            :integer(4)
#  content_type    :string(255)
#  filename        :string(255)
#  height          :integer(4)
#  width           :integer(4)
#  parent_id       :integer(4)
#  thumbnail       :string(255)
#  attachable_id   :integer(4)
#  attachable_type :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Attachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  
  validates_presence_of :filename
  
  has_attachment(
    :storage => :file_system,
    :thumbnails => { :thumb => "150x150>" },
    :content_type => :image
  )  
  
  validates_as_attachment

  attr_accessor :should_destroy 
  
  def should_destroy?
     should_destroy.to_i == 1
  end
  
end
