# == Schema Information
# Schema version: 20090814063601
#
# Table name: categories
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  has_many :vendors
  has_many :votes
  
  # for vote option  
    def common_votes
       votes.find(:all,:conditions => ["spec = ?", 1])
    end

    def avg_vote
       votes.find(:first,:conditions => ["spec = ?", 2])
    end

    def deal_vote
       votes.find(:first,:conditions => ["spec = ?", 3])
    end
    
end
