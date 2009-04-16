class Admin::ReviewsController < ApplicationController
  layout 'admin'
  before_filter :login_required
  access_control :DEFAULT => '(admin)'
  
  active_scaffold :review do |config|
      config.label = "管理评论" 
      config.actions.exclude :create
      config.columns = [:user,:vendor,:body,:ratings]
      config.update.columns.exclude [:user,:vendor,:ratings]     
  end
  
end
