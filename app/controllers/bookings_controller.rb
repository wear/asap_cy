class BookingsController < ApplicationController
  before_filter :login_required, :only => [:index]      
  before_filter :find_vendor,:except => [:index]  
  include FaceboxRender
   
  def index
    @user = current_user
    @bookings = @user.bookings.paginate :page => params[:page]

    respond_to do |format|
      format.html { render :layout => 'users' } 
      format.xml  { render :xml => @bookings }
    end
  end

  # GET /bookings/1
  # GET /bookings/1.xml
  def show
    @booking = Booking.find(params[:id])
    sent_params = params_builder(@booking,{:command => 'Submit',:user_id => @booking.mobile,:phone => '+86' + @booking.mobile})
    resource = RestClient::Resource.new 'http://www.hesine.com/openapi'   
    @res = Crack::XML.parse(resource.post(sent_params, :content_type => 'application/xml'))['Xml']
    respond_to do |format|
      format.html { render :text => @res }
      format.xml  { render :xml => @booking }
    end
  end
  
  def new 
    @user = current_user || session[:mobile_user]
    store_location
    respond_to do |wants|
      unless @user.nil?
       @booking = @user.bookings.new
       @booking.mobile = @user.mobile
        wants.html {  }
        wants.js{ }
      else       
        wants.html{ redirect_to login_path  }
        wants.js{ render_to_facebox(:template => '/sessions/new'  )}
      end
    end  
  end
  

  def create  
    @user = current_user || session[:mobile_user]  
    @vendor = Vendor.find params[:vendor_id]
    respond_to do |wants| 
      if @user
          @booking = @user.bookings.build(params[:booking])
          if @booking.save
            @user.contacts.find_or_create_by_name(:email => @booking.email,
                                                  :name => @booking.contact, 
                                                  :mobile => @booking.mobile)
            sent_params = params_builder(@booking,{:command => 'Submit',:user_id => @booking.mobile,:phone => '+86' + @booking.mobile})
            resource = RestClient::Resource.new 'http://www.hesine.com/openapi'   
            logger.info Hesine::Response.cn_message(Crack::XML.parse(resource.post(sent_params, :content_type => 'application/xml'))['Xml']['StatusCode'])                                      
            wants.html { redirect_to vendor_booking_path(@vendor,@booking) }
          else
            wants.html { render :action => "new"}
          end
      else
          wants.html { redirect_to @vendor }
      end
    end
 end
  
  def edit
    @user =  session[:booking_user]
    @booking = Booking.find(params[:id])
  end 
  
  def update
    @booking = Booking.find(params[:id])
    
    if @booking.update_attributes(params[:booking])
      respond_to do |wants|
        wants.html { redirect_to vendor_booking_path(@vendor,@booking) }
      end
    else
      respond_to do |wants|
        wants.html { render :action => "edit" }
      end
    end
  end


  # DELETE /bookings/1
  # DELETE /bookings/1.xml
  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to(bookings_url) }
      format.xml  { head :ok }
    end
  end  
  
  def bookment
    
  end
  
  private   

    def find_vendor
      @vendor = Vendor.find(params[:vendor_id])
    end
    
    def bookable_required
      @vendor = Vendor.find(params[:vendor_id])
      
      redirect_to bookment_vendor_bookings_path(@vendor)
    end     
    
    def params_builder(booking,prarams = {})         
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
            data.Message{
              data.Type('Hesine')
              data.From('<support@daorails.com>') 
              data.To(prarams[:phone])
              data.Subject('你在daorails.com的餐馆预定信息')
              data.Body("餐馆名称:#{booking.vendor.name},地址:#{booking.vendor.address}.
              就餐人数:#{booking.guest_count},就餐时间:#{booking.date} #{booking.time_range}.预定联系人:#{booking.contact}")
              data.NumOfAttach('0')
            }
          }
        }
        return out_string  
    end 

end

