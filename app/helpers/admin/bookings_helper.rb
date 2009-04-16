module Admin::BookingsHelper
  def booking_user_name(bookinguser)
     case bookinguser.class.name
       when "MobileUser"
         bookinguser.mobile
       when "User" 
         bookinguser.login
       end
  end
  
  def format_booking_time(booking)
     booking.date.strftime("%m-%d") + " - " + TIMERANGE[booking.time_range].first
  end
  
  def booking_state(booking)
   case booking.current_state
     when :pending
       '等待确认'
     when :running
       '已确认,等待商户费用'
     when :closed
       '已完成'
       end  
  end 
  
  def edit_booking_state(booking)
     case booking.current_state
     when :pending
       link_to '确认通过，开始执行订单',run_admin_booking_path(booking),:method => :put
     when :running
       link_to '已收到商户费用,关闭订单',close_admin_booking_path(booking),:method => :put 
     end
  end
end
