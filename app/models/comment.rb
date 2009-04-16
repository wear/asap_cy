# == Schema Information
# Schema version: 20081223080043
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  body             :text
#  user_id          :integer(4)
#  commentable_id   :integer(4)
#  commentable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base 
    belongs_to :user
    belongs_to :commentable, :polymorphic => true
    
    validates_presence_of :body
    validates_length_of :body, :within => 10..800, :message => "必须大于10个字符" 
    validates_associated :user   
end
