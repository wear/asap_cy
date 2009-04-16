# == Schema Information
# Schema version: 20081223080043
#
# Table name: votes
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  category_id :integer(4)
#  spec        :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  short_name  :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Vote do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    Vote.create!(@valid_attributes)
  end
end
