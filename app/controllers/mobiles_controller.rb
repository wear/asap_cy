class MobilesController < ApplicationController
  include FaceboxRender             
  def index          
    
    @res = Hesine.request(:command => 'Bind',:user_id => 'wear',:phone => '+8615001912259',:verify_code => '365922')
    respond_to do |wants|
     wants.html {  }
    end
  end 
  
  def verify
    @res = Hesine.request(:command => 'Bind',:user_id => params[:phone],:phone => '+86' + params[:phone])
    respond_to do |wants|
      wants.js { render :text => Hesine::Response.cn_message(@res['StatusCode']) }
    end
  end 
  
  def new
    @mobile_user = MobileUser.new
    @vendor = Vendor.find(params[:vendor_id])
     respond_to do |wants|
      wants.html {  }
      wants.js { render_to_facebox }
     end
  end    
  
  def create
    @mobile_user = MobileUser.find_or_create_by_mobile(params[:mobile_user])
    @vendor = Vendor.find(params[:vendor_id])
    respond_to do |wants|
      if @mobile_user.save
        wants.html {redirect_to :action => "new" } 
        wants.js {
          session[:mobile_user] = @mobile_user 
        render  :update do |page|  
          page.redirect_to new_vendor_booking_path(@vendor)   
        end 
        } 
      else  
        wants.html {redirect_to :action => "new" }
        wants.js { 
          render  :update do |page|  
            page.replace_html 'error_msg', error_messages_for(:mobile_user)    
          end
          }
      end 
    end        
  end 
  
  
end
