class MobilesController < ApplicationController
  include FaceboxRender 
  
  def index
     @res = Hesine::Bundle.unbind(:phone => '15001912259')
     respond_to do |wants|
      wants.html {  }
     end
  end       
  
  def verify    
    @exist_user = MobileUser.find_by_mobile(params[:phone])
    @mobile_user =  @exist_user.nil? ? MobileUser.create(:mobile => params[:phone]) : @exist_user
    respond_to do |wants|
      if @mobile_user && @mobile_user.status == 'pending' 
        Hesine::Bundle.bind(:phone => params[:phone])['StatusCode']
        if @res == '405'  
          @mobile_user.open!
          wants.js { render :text => '已绑定'}
        else
          wants.js { render :text => "绑定短信已发送，请按短信提示操作" } 
        end
      else
        wants.js { render :text => '可能已绑定，请直接点击下一步'}  
      end
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
    @mobile_user = MobileUser.find_by_mobile(params[:mobile_user][:mobile])
    @vendor = Vendor.find(params[:vendor_id])
    respond_to do |wants|
      if @mobile_user && @mobile_user.status == 'opened'
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
            page.replace_html 'error_msg','手机号码未绑定' 
          end
          }
      end 
    end        
  end        

  
end
