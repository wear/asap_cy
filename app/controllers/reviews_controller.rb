class ReviewsController < ApplicationController
  
 before_filter :login_required, :except => [:index,:show]
 
 def index
    @user = User.find params[:user_id] 
    @reviews = @user.reviews.paginate  :page => params[:page], :per_page => 10              
    respond_to do |wants|
      wants.html {  render :layout => 'users' }
    end
 end 
 
 def show                               
   @vendor = Vendor.find(params[:vendor_id])
   @review = Review.find params[:id]
   @user = @review.user 
   respond_to do |wants|
    wants.html {}
   end
 end
 
 def edit
   @user = current_user
   @review = current_user.reviews.find(params[:id])
   @ratings = @review.ratings.find(:all,:include => [:vote],:order => "votes.spec ASC")   
   @vendor = @review.vendor
 end
 
 def update 
    params[:review][:existing_rating_attributes] ||= {}
   
    @user = current_user
    @review = @user.reviews.find params[:id]
    respond_to do |wants|
      if @review.update_attributes(params[:review]) 
         @review.vendor.update_score_sumary
         wants.html { redirect_to vendor_review_path(@review.vendor,@review)}
       else
         wants.html { render :action => "edit"}
      end
    end
 end
  
  def create
      @user = current_user
      @vendor = Vendor.find(params[:vendor_id])
      @review = @user.reviews.new(params[:review])
      respond_to do |wants|
        if @review.save
          @vendor.update_score_sumary 
          flash[:notice] = '点评发布成功！'
          wants.html { redirect_to vendor_path(@vendor) }
          wants.js {} 
        else
          wants.html {}        
          wants.js {render :template => "/reviews/error"}
        end
      end
  end
  
  
end
