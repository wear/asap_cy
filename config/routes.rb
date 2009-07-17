ActionController::Routing::Routes.draw do |map|


  map.resources :merchants do |merchant|
    merchant.resources :vendors
    merchant.resources :users
  end
  map.send_verify_code '/send_verify_code/:phone', :controller => 'mobiles', :action => 'verify',:phone => nil  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.login_box '/login_box', :controller => 'sessions', :action => 'login_box'
  map.setting '/admin/setting', :controller => 'admin', :action => 'setting' 
  map.login_status '/login_status', :controller => 'sessions', :action => 'login_status'
  map.forgot_password '/forgot_password',:controller => 'users', :action => 'forgot_password'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.openapi '/openapi',:controller => 'landing',:action => 'openapi'
  map.cached_list 'list/:cached_list', :controller => 'vendors',  :action => 'cached_list', :cached_id => nil    
  
  map.resources :users,:member => {:setting => :get, :password => :get, :change_password => :put, :avatar => :get, 
    :change_avatar => :put, :profile => :get },:collection => {:reset_password => :put}, :has_many => [:reviews,:bookings] do |user|
    user.resources :discounts,:member => { :close => :put }
  end
  
  map.resources :forums do |forum|
    forum.resources :topics do |topic|
      topic.resources :posts
    end
  end
  
  map.resources :areas, :has_many => :types
  map.resource :session
  
  map.resources :types,:has_many => [:vendors,:areas]
  
  map.resources :vendors, :collection => {:new_search => :get },:member => { :head => :get, :book => :get, :map => :get } do |vendor|
    vendor.resources :reviews do |review| 
        review.resources :comments      
    end   
    vendor.resources :bookings,:member => { :run => :get  }, :collection => { :login_as_user => :get,:login_as_mobile => :get, :bookment => :get }
    vendor.resources :mobiles
  end

  map.root :controller => "landing" 
  
  map.namespace :admin do |admin|
    
    admin.with_options(:active_scaffold => true) do |scaffold|
      scaffold.resources :categories
      scaffold.resources :users
      scaffold.resources :areas
      scaffold.resources :reviews
      scaffold.resources :roles
      scaffold.resources :votes      
      scaffold.resources :types
      scaffold.resources :discounts
    end                            
    
    admin.with_options(:collection => { :search => :get }) do |scaffold|
      scaffold.resources :merchants, :member => { :users => :get,:delete_user => :put,:search_users => :get, 
                                                  :vendors => :get, :delete_vendor => :put, :search_vendors => :get }
      scaffold.resources :users  
      scaffold.resources :cards
      scaffold.resources :bookings,:member => { :close => :put, :run => :put }
      scaffold.resources :vendors, :collection => {:search => :get, :pending => :get } 
    end  
  end
  
  
  map.comatose_admin "admin/comatose",:layout => 'admin'    
  map.comatose_news 'news',  :index=>'news',:layout => 'application'
  
  map.comatose_help  "help", :index=>'help', :layout => 'application'
  map.comatose_about  "about",  :index=>'about',:layout => 'application'

  map.connect ':controller/:action/:id' 
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action.:format'
end
