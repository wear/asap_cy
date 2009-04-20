class Admin::UsersController < ApplicationController
  layout 'admin'
  before_filter :login_required
  access_control :DEFAULT => '(admin)'
  
  active_scaffold :users do |config|
      config.label = "管理用户"
      config.columns = [:login,:email,:roles]
      config.actions.exclude :create
      config.update.columns.exclude [:login,:email]  
  end
end
