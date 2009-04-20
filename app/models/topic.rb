# == Schema Information
# Schema version: 20081223080043
#
# Table name: topics
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  body       :text
#  user_id    :integer(4)
#  forum_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Topic < ActiveRecord::Base
  belongs_to :forums
  has_many :comments, :as => 'commentable' 
end
