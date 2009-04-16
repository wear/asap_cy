# == Schema Information
# Schema version: 20081223080043
#
# Table name: reviews
#
#  id         :integer(4)      not null, primary key
#  body       :text
#  vendor_id  :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Review < ActiveRecord::Base
  belongs_to :vendor, :counter_cache => true 
  belongs_to :user
  has_many :ratings
  has_many :comments, :as => 'commentable'      
  
  validates_length_of :body, :within => 10..800, :message => "必须大于10个字符"  
  validates_associated :ratings
  
  after_update :save_ratings
  
  named_scope :lastest_create, :order => 'created_at ASC' 
  
  acts_as_taggable_on :tags, :dishes
  
  def validate_on_create
    errors.add_to_base("不能评论多次") if user.reviews.find_by_vendor_id(vendor_id)
  end
 
 def new_rating_attributes=(rating_attributes)
   rating_attributes.each do |index,attributes|
     ratings.build(attributes)
   end
 end
 
 def existing_rating_attributes=(rating_attributes)
   ratings.reject(&:new_record?).each do |rating|
     attributes = rating_attributes[rating.id.to_s]
     if attributes
       rating.attributes = attributes
     end
   end
 end
 
 def save_ratings
   ratings.each do |rating|
     rating.save(false)
   end
 end
 
 protected

  
end
                                              
