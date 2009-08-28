# == Schema Information
# Schema version: 20090814063601
#
# Table name: ratings
#
#  id         :integer(4)      not null, primary key
#  review_id  :integer(4)
#  score      :integer(4)      default(0)
#  vote_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Rating < ActiveRecord::Base
  belongs_to :review
  belongs_to :vote
  
  validates_presence_of :score
  validates_numericality_of :score
   
  #here to update total score, need modify
#  after_save :sumarize
  named_scope :by_spec, lambda { |*args| {:include => :vote,:conditions => [ "votes.spec = ?", args.first]}}
  named_scope :by_vote, lambda { |*args| {:conditions => [ "vote_id = ?", args.first]}}
  def sumarize
     summary_item.update_attribute(:score,sumarize_score)
  end
  
  def sumarize_score
    if summary_item.new_record?
      summary_item.score
    else
      summary_item.score + self.score
    end
  end
 
  def summary_item
    ScoreSumary.find_or_create_by_vendor_id_and_vote_id(review.vendor_id,vote_id) 
  end
end
