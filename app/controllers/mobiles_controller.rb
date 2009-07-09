require 'net/http'                             
require 'uri'

class MobilesController < ApplicationController
  include FaceboxRender             
  def index
    data =  Builder::XmlMarkup.new 
    data.instruct!  
    data.XML{
      data.System{
        data.SystemID("mhqx001")
        data.MsgID('0')
        data.Signature("tellmewhy")
        data.Command('Bind')
      } 
      data.User{
        data.UserId("wear")
        data.Phone("+8615001912259") 
        data.VerifyCode("3659220")
      }
    }
    
    url = URI.parse('http://www.hesine.com/openapi')
    req = Net::HTTP::Post.new(url.path)
    req["content-type"] = "application/xml"
    req.body = data
    @res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
    
    respond_to do |wants|
      wants.html {  }
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
