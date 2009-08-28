# == Schema Information
# Schema version: 20090814063601
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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Review do
  before(:each) do
    @valid_attributes = {
      :body => "testetstesttests"
    }
  end

  it "should create a new instance given valid attributes" do
    Review.create!(@valid_attributes)
  end
end
