class Admin::VotesController < ApplicationController 
  layout 'admin'
  before_filter :login_required
  access_control :DEFAULT => '(admin)'
    
  active_scaffold :vote do |config|
    config.label = "管理投票项"
    config.columns = [:name,:spec, :short_name]
    config.columns[:spec].label = "类型: 1位普通,2是均价,3是总评"
  end 
end
