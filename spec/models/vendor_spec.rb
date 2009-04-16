# == Schema Information
# Schema version: 20081223080043
#
# Table name: vendors
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  address       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  description   :text
#  nearby        :string(255)
#  alias         :string(255)
#  tel1          :integer(4)
#  tel2          :integer(4)
#  area_id       :integer(4)
#  category_id   :integer(4)
#  reviews_count :integer(4)      default(0)
#  merchant_id   :integer(4)
#  discount_id   :integer(4)
#  pending       :boolean(1)      default(TRUE)
#  creator_id    :integer(4)
#  author_id     :integer(4)
#  version       :integer(4)      default(1)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Vendor do
  fixtures :reviews,:vendors,:categories,:votes,:users      
  
  before(:each) do
    @category = Category.find(:first)
    @valid_attributes = { 
      :category => @category
    }
  end

  it "should create a new instance given valid attributes" do
    Vendor.create!(@valid_attributes)
  end 
  
  it "should save initial score" do 
    vendor = Vendor.create!(@valid_attributes)
    vendor.rates.size == 3
  end 
end
