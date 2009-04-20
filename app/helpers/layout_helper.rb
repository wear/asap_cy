module LayoutHelper
  def title(page_title)
    @content_for_title = page_title.to_s
  #  @show_title = show_title
  end
  
  def body_tag(map = false)
     body = map ?  "<body onload='initialize()' onunload='GUnload()'>" : "<body>"
     @content_for_body_tag = body
  end
  
  def sub_title(sub_title)
    @content_for_sub_title = sub_title.to_s  
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end
  
  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def page_nav(nav)
     @content_for_page_nav = link_to('首页','/') + ' - ' + nav
  end 
  
end