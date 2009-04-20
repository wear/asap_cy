require File.dirname(__FILE__) + '/../spec_helper'

describe ReviewsController do
  include AuthenticatedTestHelper 
  fixtures :reviews,:vendors,:categories,:votes,:users   
    
  before(:each) do
    @vendor = mock_model(Vendor, :update_score => 3)
    @review = mock_model(Review, :save => true)
    @rating = mock_model(Rating, :save => true)
    @review.stub!(:ratings).and_return(mock(Array,:build => @rating)) 
    Vendor.stub!(:find).and_return(@vendor)
    Review.stub!(:new).and_return(@review) 
    controller.stub!(:current_user).and_return(mock_user)
  end 
  
  def do_post
    post :create, :vendor_id => 1,
      :votes =>{"1"=>"-1",
      "2"=>"-1",
      "3"=>"2",
      "4"=>"22"},
      :body => "afsdsdaffdsfds"
  end
  
  it "should save with valid input" do
    do_post 
    response.should redirect_to(vendor_path(@vendor))
  end
  
  it "should not save without valid input" do
  end
end