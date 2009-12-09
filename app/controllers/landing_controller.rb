class LandingController < ApplicationController 
  caches_page :index

 def index 
     @search_params = params[:search] || {} 
     @search= Vendor.avg_greater_than(100)  
     @vendors = @search.find(:all,:limit => 30,:order => 'sum DESC')
     respond_to do |wants|
      wants.html 
     end
  end 
  
  def help
  end 

  
end
