class AreasController < ApplicationController
  def show 
     build_sort
     @area = Area.find params[:id] 
     @areas = Area.find(:all,:conditions => ['parent_id = ?',1])
     @types = Type.find(:all,:conditions => ['parent_id = ?',1])
     @type = Type.find params[:type_id] if params[:type_id]
     @query = "#{@area.name} #{(' AND ' + @type.name)  if @type}"
     @vendors = Vendor.full_text_search(@query,{:per_page => 50, :page => params[:page]}, {},@sort) 
  end
end
