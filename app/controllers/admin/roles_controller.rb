class Admin::RolesController < ApplicationController 
  layout 'admin'
  before_filter :login_required
  access_control :DEFAULT => '(admin)'
  
  active_scaffold :roles do |config|
      config.label = "管理权限"
      config.columns = [:title] 
  end
end
