module AdminHelper
  def image_for(card, size=120)
    if card.images_exists?
      image_tag(card.attachment.public_filename , :size => "#{size}x#{size}")
    else
        image_tag('/images/lang-guest.png', :size => "#{size}x#{size}")
    end
  end 
  
end
