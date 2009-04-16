class Admin::CategoriesController < ApplicationController
    layout 'admin' 
    before_filter :login_required
    access_control :DEFAULT => '(admin)'
     
    active_scaffold :category do |config|
         config.label = "管理分类"
         config.columns = [:name,:votes]
         config.create.columns.exclude :votes
         config.update.columns.exclude :votes
    end 
end
