module DiscountsHelper
  def ad_for(discount)
     discount.attachment.nil? ? "" : link_to(image_tag(discount.attachment.public_filename(:thumb)),discount.attachment.public_filename, :target => '_blank')
  end
  
  
  # need improve for image upload
  def ad_file_field(discount,form)
  #   if 
  end
  
  def edit_discount_link(user,discount)
    unless discount.current_state == :closed
      link_to '编辑', edit_user_discount_path(user,discount)
    end 
  end
  
  def close_discount(user,discount)
    if discount.current_state == :used
      link_to '关闭本打折项', close_user_discount_path(user,discount), :method => :put 
    end
  end
end
