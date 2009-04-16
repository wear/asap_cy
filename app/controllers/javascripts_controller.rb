class JavascriptsController < ApplicationController 
  def dynamic_areas
    @areas = Area.find(:all,:conditions => 'id > 1 ')
  end 
  
  def dynamic_caixi
    @types = Type.find(:all,:conditions => 'id > 1 ')
  end
end
