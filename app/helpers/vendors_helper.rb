module VendorsHelper
  def show_discount(vendor)
    vendor.discount.nil? ? '' : content_tag('br',
    content_tag(:label,'名称') + ':' + vendor.discount.name) + content_tag('br',
    content_tag(:label,'折扣') + ':' + vendor.discount.count.to_s)
  end
  
  def online_booking_link(vendor)
    if logged_in?
      link_to(image_tag('icon/booking.gif'),new_vendor_booking_path(vendor))
    else
      link_to(image_tag('icon/booking.gif'),new_vendor_booking_path(vendor))  +  
      facebox_link_to(image_tag('icon/mobile-booking.gif'),:url => new_mobile_path(:vendor_id => vendor.id))        
    end
  end 
  
  
  def tag_filte(obj,query) 
    new_query =  query + " AND " + obj.name
    total_hits = Vendor.total_hits(new_query)
    unless total_hits == 0
      content_tag(:li,link_to(obj.name,vendors_path(:query => new_query,:cache_id => make_cache_id(new_query))) + "(" + total_hits.to_s + ")")
    end
  end
  
end
