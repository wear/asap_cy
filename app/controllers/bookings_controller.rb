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

    respond_to do |format|
      format.html # show.html.erb
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
    

end

