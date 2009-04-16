class VendorsController < ApplicationController

  acts_as_iphone_controller   
#  after_filter :store_location, :only => [:index, :new, :show, :edit]
#  before_filter :login_required, :only => [:edit,:update,:new,:create]

#  include FaceboxRender
  caches_action :index, :if => Proc.new { |c| !c.params[:cache_id].nil? },:cache_path => Proc.new { |controller|
    controller.send(:cached_list_url, controller.params[:cache_id]) }

  
  def index
    build_query
    @vendors = Vendor.full_text_search(@query,{:per_page => 30,:page => params[:page]},{},@sort)
    @caixis = Type.find(:all,:conditions => ['parent_id =?',1])
    @areas = Area.find(:all,:conditions => ['parent_id =?',1])
    @avg_prices = Type.find(:all,:conditions => ['parent_id =?',77])
    respond_to do |wants|
     wants.html {}
     wants.iphone { }
    end
  end
  
  def cached_list
    
  end
  
  def show
     @vendor = Vendor.find(params[:id],:include => [:reviews])
      if logged_in? 
        if current_user.reviewed?(@vendor)
          @review = current_user.vendor_review(@vendor)
        else
          @review = @vendor.reviews.new
          @ratings = @vendor.category.votes.order_by_spec.collect{|vote| @review.ratings.build(:vote => vote )}
        end
      end
    respond_to do |wants|
      wants.html {  }
      wants.js { }
      
      wants.iphone {}
    end
  end
  
  def head
    @vendor = Vendor.find(params[:id]) 
    respond_to do |wants|
      wants.html {  }
      wants.js { }
      wants.iphone {}
    end
  end
  
  def new 
     @areas = Area.find(:all,:conditions => ["parent_id = ?",1])
     @vendor = Vendor.new
  end
  
  def create
    @vendor = current_user.vendors.new(params[:vendor])

    respond_to do |format|
      if @vendor.save
        flash[:notice] = '创建成功.'
        format.html { redirect_to current_user }
        format.xml  { render :xml => @vendor, :status => :created, :location => @vendor }
      else    
        format.html { render :action => "new" }
        format.xml  { render :xml => @vendor.errors, :status => :unprocessable_entity }
      end
    end    
  end
  
  def new_search
    build_query
      @vendors = Vendor.full_text_search(@query,{:per_page => 50,:page => params[:page]},{},@sort)
    respond_to do |wants|
      wants.html { }
      wants.iphone {  }
    end
  end
  
  def update
    @vendor = Vendor.find params[:id]     
    
    respond_to do |wants|
      if @vendor.update_attributes(params[:vendor]) 
        wants.html { redirect_to @vendor }
      else 
        wants.html { render :action => "edit" } 
      end
    end
  end
  
  def book
    @vendor = Vendor.find params[:id]
  end 
  
  def edit
    @vendor = Vendor.find params[:id]
    @discounts = current_user.discounts
  end
  
  def map
    @vendor = Vendor.find(params[:id])
    respond_to do |wants|
      wants.html { render :layout => 'application' }
      wants.js {}
    end
  end 

  protected
  
  def check_cache
    
  end
  
  def passed?(field)
    field.blank? ? '' : field.to_i
  end
  
  def permission_denied
    flash[:notice] = "You don't have privileges to access this action"
    return redirect_back_or_default('/')  
  end         
  
end
