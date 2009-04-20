class Admin::AreasController < ApplicationController
  layout 'admin' 
  before_filter :login_required
  access_control :DEFAULT => '(admin)'
   
  active_scaffold :area do |config|
       config.label = "管理分类"
       config.columns = [:name,:order,:parent_id,:children] 
  end 

end
