class MobilesController < ApplicationController
  include FaceboxRender 
  
  def index
   # sent_params = params_builder(:command => 'UnBind',
	 # :user_id => '15001912259',:phone => '+8615001912259')
   # resource = RestClient::Resource.new 'http://www.hesine.com/openapi'
   # @res = Crack::XML.parse(resource.post(sent_params, :content_type => 'application/xml'))['Xml'] 
   @res = Hesine::Message.send(:phone => '15001912259',:from => '"stephen"<support@mhqx001>',:to => "test@mhqx001",
   :subject => 'sfafa',:body => 'fsdfs')
    respond_to do |wants|
	wants.html { render :text => @res.inspect,:layout => false}
    end
  end

  def unbind
    sent_params = params_builder(:command => 'UnBind',:user_id => params[:phone],:phone => '+86' + params[:phone])
    resource = RestClient::Resource.new 'http://www.hesine.com/openapi'
    @res = Crack::XML.parse(resource.post(sent_params, :content_type => 'application/xml'))['Xml']

    respond_to do |wants|
      wants.js { render :text => Hesine::Response.cn_message(@res['StatusCode']) }
    end
  end           
  
  def verify    
    @exist_user = MobileUser.find_by_mobile(params[:phone])
    @mobile_user =  @exist_user.nil? ? MobileUser.create(:mobile => params[:phone]) : @exist_user
    respond_to do |wants|
      if @mobile_user && @mobile_user.status == 'pending' 
        sent_params = params_builder(:command => 'Bind',:user_id => params[:phone],:phone => '+86' + params[:phone])
        resource = RestClient::Resource.new 'http://www.hesine.com/openapi'   
        @res = Crack::XML.parse(resource.post(sent_params, :content_type => 'application/xml'))['Xml']['StatusCode']
        if @res == '405'  
          @mobile_user.open!
          wants.js { render :text => '已绑定'}
        else
          wants.js { render :text => "绑定短信已发送，请按短信提示操作"} 
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
  
protected

 def params_builder(prarams = {})         
     data = Builder::XmlMarkup.new( :target => out_string = "", :indent => 2 )
     data.instruct!  
     data.XML{
       data.System{
         data.SystemID('mhqx001')
         data.MsgID('0')
         data.Signature('zzzzzz')
         data.Command(prarams[:command])
       } 
       data.User{
         data.UserId(prarams[:user_id])
         data.Phone(prarams[:phone]) 
       }
     }
     return out_string  
 end   
 

  
end
