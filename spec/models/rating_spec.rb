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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rating do
  before(:each) do
    @valid_attributes = {
      :review_id => 1,
      :score => 3,
      :vote_id => 2 
    }
     @review = mock_model(Review,:vendor_id => 1)    
  end
  
  def build_new
    @rating = Rating.new(@valid_attributes)
    @rating.should_receive(:review).and_return(@review) 
  end

  it "should create a new instance given valid attributes" do
    build_new
    @rating.save!
  end
  
  it "should sumarize the vote's score" do
    build_new
    @rating.save!
    ScoreSumary.find(:first,:conditions => ["vendor_id = ? and vote_id = ?", 1,2]).score.should == 3
  end
end
