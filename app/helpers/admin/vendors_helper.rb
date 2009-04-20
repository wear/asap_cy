module Admin::VendorsHelper 
  include TagsHelper
  
  
  def add_attachment_link(name) 
    link_to_function name do |page| 
      page.insert_html :bottom, :attachments, :partial => '/admin/vendors/attachment', :object => Attachment.new 
    end 
  end
  
end
