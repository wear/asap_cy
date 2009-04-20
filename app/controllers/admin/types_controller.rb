class Admin::TypesController < ApplicationController 
  
  layout 'admin'
  before_filter :login_required
  access_control :DEFAULT => '(admin)'
  
  active_scaffold :types do |config|
      config.label = "管理类型"
      config.columns = [:name,:order,:parent_id,:children]
  end
  
end
