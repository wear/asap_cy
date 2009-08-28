class MobilesController < ApplicationController
  include FaceboxRender 
  
  def index
    sent_params = params_builder(:command => 'Bind',
	:user_id => '15001912259',:phone => '+8615001912259')
    resource = RestClient::Resource.new 'http://www.hesine.com/openapi'
    @res = Crack::XML.parse(resource.post(sent_params, :content_type => 'application/xml'))['Xml']

    respond_to do |wants|
	wants.html {}
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
    sent_params = params_builder(:command => 'UnBind',:user_id => params[:phone],:phone => '+86' + params[:phone])
    resource = RestClient::Resource.new 'http://www.hesine.com/openapi'   
    @res = Crack::XML.parse(resource.post(sent_params, :content_type => 'application/xml'))['Xml']

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
 
 def out_pra(pra)
  pra
  return out_string 
 end

  
end
