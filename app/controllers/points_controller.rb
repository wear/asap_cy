class PointsController < ApplicationController
  before_filter :login_required
  
  def show
    
  end   
  
  def create
     @charge = Booking.find(params[:id]) || Card.find(params[:id])
     respond_to do |wants| 
       if @charge
         @point = Point.purchase(@charger,current_user)
          if @point
           wants.html { redirect_to point_path(@point) }
          else
           flash[:error] = "charge failed"
           wants.html { redirect_back_or_default('/')  }
          end
        else
           flash[:error] = "charge failed"
           wants.html { redirect_back_or_default('/')  }
        end
     end
  end       
  
end
