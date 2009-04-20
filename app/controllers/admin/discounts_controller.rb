class Admin::DiscountsController < ApplicationController 
  layout 'admin' 
  before_filter :login_required
  access_control :DEFAULT => '(admin)'
   
  active_scaffold :discount do |config|
       config.label = "管理折扣" 
       config.columns = [:name,:count,:start_at,:stop_at,:start_date,:stop_date]
  end    
  
end
