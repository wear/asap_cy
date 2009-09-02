# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem             
  include ExceptionNotifiable
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'cdb5b2e81b5a6606c69d3d970f4e1c34'
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password  
  
  def build_sort 
    unless params[:sort].nil?
      @sort = Ferret::Search::SortField.new(params[:sort],:type => :float,:reverse => true)
      @sort_item = params[:sort]
    end 
  end
  
  def build_query
    @query = ''
    @keyword = params[:query] 
    @query << (params[:query].nil? ? '*' : params[:query])
    unless params[:search].nil?
      @area = passed?(params[:search][:area_id])
#      @district =  passed?(params[:search][:district_id])
      @caixi = passed?(params[:search][:caixi_id])
#      @caixi_child = passed?(params[:search][:caixi_child_id])
#      @search = { 'caixi_id' => @caixi,'caixi_child_id' => @caixi_child, 'district_id' => @district, 'area_id' => nil }
   #   area_id = @area.blank? ? @district : @area
   #   caixi_id = @caixi_child.blank? ? @caixi : @caixi_child
   #   @query << " AND #{Area.find(area_id).name}" unless area_id.blank?
   #   @query << " AND #{Type.find(caixi_id).name}" unless caixi_id.blank?
      @query << " AND #{Area.find(@area).name}" unless @area.blank?
      @query << " AND #{Type.find(@caixi).name}" unless @caixi.blank?
    end
  end

  def permission_denied
    flash[:error] = "您没有权限"
    redirect_to(login_path)
  end

end
