class LandingController < ApplicationController 
  caches_page :index
  skip_before_filter :verify_authenticity_token 

 def index 
     build_sort 
     build_top35
     @areas = Area.find(:all,:conditions => ['parent_id =?',1])
     @types = Type.find(:all,:conditions => ['parent_id =?',1],:include => :vendors )
     @prices =  Type.find(:all,:conditions => ['parent_id =?',77],:include => :vendors ) 
     @nice = Vendor.full_text_search('121-200 OR 201',{ :per_page => 30,:page => params[:page]},{},@sort)
     @recent_reviews = Review.find(:all,:order => "created_at DESC", :limit => 5) 
     @votes = Vote.find(:all)
     respond_to do |wants|
      wants.html 
     end
  end 
  
  def help
  end 
  
  def hesine  
#    xml = request.parameters['<?xml version'] 
#    bind_result = Hesine::Response.bind?(xml)
#    if bind_result
#      @user = MobileUser.find_by_mobile(bind_result)
#      @user.open! 
#    end
  end
  
  protected
  
  def build_top35
    avg_20 = Vendor.full_text_search('20-50',{ :per_page => 5,:page => params[:page]},{},@sort)
    avg_50 = Vendor.full_text_search('51-80',{ :per_page => 5,:page => params[:page]},{},@sort) 
    avg_100 =  Vendor.full_text_search('81-121',{ :per_page => 10,:page => params[:page]},{},@sort)
    avg_150 =  Vendor.full_text_search('121-200',{ :per_page => 5,:page => params[:page]},{},@sort)
    avg_200 =  Vendor.full_text_search('201以上',{ :per_page => 5,:page => params[:page]},{},@sort)
    @vendors = avg_20 + avg_50 + avg_100 + avg_150 + avg_200
  end  
  
end
