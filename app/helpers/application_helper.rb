# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper 
  # Displays flash notifications
  def flash_div 
    flash.keys.collect { |key| content_tag( :div, flash[key], :class => "flash-msg f_#{key}" ) if flash[key] }.join
  end  
  
  def logged_scope(&block)
    yield block if logged_in?
  end
  
  def make_score(score)
     # new_score = (score*10).to_i/10.0
     # new_score > 5.0 ? 5.0 : new_score
     new_score = ((score/7)*10).round.to_f/10
     new_score > 5.0 ? 5.0 : new_score
  end
  
  def admin_scope(&block)
    yield block if logged_in? && current_user.admin?
  end
  
  def owner_scope(&block)
    yield block if logged_in? && current_user.owner?
  end
  
  def current_user_scope(user,&block)
    yield block if current_user == user          
  end
  
  def star(vendor) 
    case vendor.total.score
    when 2..11
      "onestar"
    when 11..14
      "twostar"
    when 14..18
      "threestar"
    when 18..22
      "fourstar"
    when 22..1000
      "fivestar"
    end 
  end
  
  
  def login_or_render(label,login_type,render_path)
    if logged_in?
      link_to label,render_path
    else    
      case login_type 
      when "normal"
        link_to_function label,"jQuery.facebox(#{(render :partial => '/shared/user_login_or_create').to_json})"
      when "mobile" 
        link_to_function label,"jQuery.facebox(#{(render :partial => '/shared/mobile').to_json})"
      end
    end
  end
  
  def booking_vendor_path(vendor)
    if logged_in?
      link_to_remote '预定', :url => new_vendor_booking_path(vendor)
    else
      link_to_remote '预定', :url => new_vendor_mobile_path(vendor)
    end
  end
  

   def error_messages_for(*params)
     options = params.extract_options!.symbolize_keys
     objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
     count   = objects.inject(0) {|sum, object| sum + object.errors.count }
     unless count.zero?
       html = {}
       [:id, :class].each do |key|
         if options.include?(key)
           value = options[key]
           html[key] = value unless value.blank?
         else
           html[key] = 'error'
         end
       end
       header_message = "出错了，出错了!"
       error_messages = objects.map {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg) } }
       content_tag(:div,
         content_tag(options[:header_tag] || :div, header_message ,:id => 'error_h') <<
           content_tag(:div,
           content_tag(:strong, '请检查以下项目:', :id => 'c' ,:style => 'font-size:14px') <<
           content_tag(:ul, error_messages), :id => 'error_i') <<
           content_tag(:div, '&nbsp;', :id => 'error_f'),
         html
       )
     else
       ''
     end
   end 

       
  def format_discount(vendor)
    if vendor.discount
      vendor.discount
    else
      '暂无'
    end
  end                          
  
  def full_distance_time(discount)
    distance_date(discount.start_date,discount.stop_date) + ' ' +  distance_time(discount.start_at,discount.stop_at)
  end
  
  def distance_time(start,stop)
     start.strftime("%H")+"点到"+stop.strftime("%H")+"点" 
  end
  
  def distance_date(start,stop)
    start.strftime("%m-%d")+"/"+stop.strftime("%m-%d") 
  end
  
  def formated_time(time)
     time.strftime("%m-%d %H:%M")
  end
  
  def formated_date(date)
    date.strftime("%m-%d")
  end
  
  def booktime(time)
    TIMERANGE[time].first
  end
  
  def button_link_to(name, options, html_options = nil)
    html_options[:class] = "button"
    link_to(name, options, html_options)
  end
  
  def iui_toolbar(initial_caption, search_url = nil)
    back_button = button_link_to("", "#", :id => "backButton")
    header = content_tag(:a, initial_caption,:href => "/", :id => "header_text")
    search_link = if search_url 
                  then button_link_to("查找", search_url, :id => "searchButton")
                  else ""
                  end 
    content = [back_button, header, search_link].join("\n")
    content_tag(:div, content, :class => "toolbar")
  end
  
  def avatar_for(user, size=48)
    
    if user.avatar_exists?
      image_tag(image_path(user.avatar_path), :size => "#{size}x#{size}",:align => "Middle")
    else
    #  if user.roles.empty?
        image_tag(image_path('/images/lang-guest.png'), :size => "#{size}x#{size}",:align => "Middle")
    #  else
    #    image_tag(user.roles.first.avatar_path, :size => "#{size}x#{size}")        
   #   end
    end
  end
  
  
  def formatted_content(review)
    if review.body.size > 80
      truncate(display_br(review.body),80) + link_to('详情',vendor_review_path(review.vendor,review))
    else
      display_br(review.body)
    end
  end
  
  def display_br(t)
		h(t).gsub(/([^\n]\n)(?=[^\n])/, '\1<br />')
	end 
	
	def checked?(collection,id)
    return false if collection.blank?  
    collection.map(&:id).include?(id)
  end
  
  def tag_area(tags,&block)
    yield block unless tags.blank? 
  end 
  
  def full_name_for(vendor)
    h(vendor.name + (vendor.alias.nil? ? '' : '(' + vendor.alias + ')'))
  end
  
  def nick_name_for(user)
    h((user.name.nil? ||user.name.blank?) ? user.login : user.name )
  end
  
  def full_address_for(vendor)
    h((vendor.nearby.nil? || vendor.nearby.blank?) ? vendor.address : vendor.address +  '(近' + vendor.nearby + ')')     
  end
  
  def type_of_caixi(vendor)
     vendor.types.blank? ?  '' : link_to(vendor.types.first.name,type_path(vendor.types.first))
  end
  
  def comment_content(comment,review,vendor,limit = true) 
      if comment.body.size > 200 && limit 
        truncate(display_br(comment.body),200) + link_to('详情',vendor_review_comment_path(vendor,review,comment))
      else
        display_br(comment.body)
      end
  end
  
  def show_filter(filters)
    filters.children.blank? ? filters.parent : filters 
  end
  
  def vendor_status(vendor)
    vendor.pending ? "有待确认" : "已通过"
  end
  
  def booking_discount(booking)     
    # need add version
     booking.discount.nil?  ? '无折扣' : booking.discount.count
  end
  
  
  def link_to_filter(filter,current_filter,more_filter = nil)  
    if filter == current_filter
        content_tag('li', filter.name,:class => 'c_f')
      else
      if more_filter 
        case more_filter
        when Area
          content_tag('li',link_to(filter.name,area_type_path(more_filter,filter)) + "("+ filter.vendors_count.to_s + ")")
        when Type 
          content_tag('li',link_to(filter.name,type_area_path(more_filter,filter))+ "("+ filter.vendors_count.to_s + ")")
        end
      else
        content_tag('li',link_to(filter.name,filter)+ "("+ filter.vendors_count.to_s + ")")
      end
    end    
  end
  
  def fomatted_query(query) 
    query.gsub(/AND/,'') if query
  end
  
  def fengdian_link(vendor)
     if vendor.name.match(/店\)/)
       link_to '所有分店',vendors_path(:query => vendor.name.split('(')[0]),:target => '_blank' 
     end
  end
  
  def short_num(num)
     (num > 1000) ? '1K+' : num
  end
  
  def make_cache_id(query)
    Digest::SHA1.hexdigest(query)
  end 
  
  def cached_link(type_id)
     t = Type.find(type_id)
   return  vendors_path(:query => t.name,:cache_id => make_cache_id(t.name))
  end
  
end
