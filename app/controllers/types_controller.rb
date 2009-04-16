class TypesController < ApplicationController
  def show  
    build_sort 
    build_query
    @areas = Area.find(:all,:conditions => ['parent_id = ?',1])
    @types = Type.find(:all,:conditions => ['parent_id = ?',1]) 
    @type = Type.find params[:id]
    @area = Area.find params[:area_id] if params[:area_id]
    @query = "#{(@area.name + ' AND ') if @area} #{@type.name}"  
    @vendors = Vendor.full_text_search(@query,{ :per_page => 50,:page => params[:page]}, {},@sort)  
  end
end
