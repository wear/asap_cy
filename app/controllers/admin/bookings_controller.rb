class Admin::BookingsController < ApplicationController  
  layout 'admin' 
  before_filter :login_required
  access_control :DEFAULT => '(admin)'
  before_filter :find_booking, :except => [:index] 
  def index
     @bookings = Booking.paginate(:all,:order => "created_at DESC", :page => params[:page] )
  end
  
  def show
  end
  
  def run
    @booking.run!
    
    respond_to do |format|
      flash[:notice] = '订单状态已修改'
      format.html { redirect_to admin_booking_path(@booking) }
      format.xml  { head :ok }
    end
  end
  
  def close
    @booking.close!
    respond_to do |format|
      flash[:notice] = '订单已关闭'
      format.html { redirect_to admin_booking_path(@booking) }
      format.xml  { head :ok }
    end
  end
  
  def edit
  end
  
  def destroy
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to(admin_bookings_path) }
      format.xml  { head :ok }
    end    
  end 
  
  protected
  
  def find_booking
    @booking = Booking.find(params[:id])
  end
end
