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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ScoreSumary do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    ScoreSumary.create!(@valid_attributes)
  end
end
