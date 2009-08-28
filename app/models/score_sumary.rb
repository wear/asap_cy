# == Schema Information
# Schema version: 20090814063601
#
# Table name: score_sumaries
#
#  id         :integer(4)      not null, primary key
#  vote_id    :integer(4)
#  score      :float           default(0.0)
#  vendor_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class ScoreSumary < ActiveRecord::Base
  belongs_to :vote
  belongs_to :vendor 
  
  named_scope :common_votes, :include => :vote, :conditions => ['votes.spec = ?',VOTESPEC["COMMON"]]
end
