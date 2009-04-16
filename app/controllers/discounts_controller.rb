class DiscountsController < ApplicationController 
  
  before_filter :login_required 
  before_filter :find_user
  access_control :DEFAULT => '(owner)' 
  layout 'users'
  
  # GET /discounts
  # GET /discounts.xml
  def index 
    @discounts = @user.discounts
    @vendors = @user.merchant_vendors
     
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vendors }
    end
  end

  # GET /discounts/1
  # GET /discounts/1.xml
  def show
    @discount = current_user.discounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @discount }
    end
  end
  
  def vendors
    @vendors = @user.merchant.vendors.find(:all)
  end

  # GET /discounts/new
  # GET /discounts/new.xml
  def new
    @discount = @user.discounts.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @discount }
    end
  end

  # GET /discounts/1/edit
  def edit
    @discount = current_user.discounts.find(params[:id])
  end

  # POST /discounts
  # POST /discounts.xml
  def create
    @discount = @user.discounts.new(params[:discount])
    respond_to do |format|
      if @discount.save
        flash[:notice] = 'Discount was successfully created.'
        format.js { }
        format.html { redirect_to(user_discounts_path(@user)) }
        format.xml  { render :xml => @discount, :status => :created, :location => @discount }
      else    
        format.js   { render :template => "discounts/faile"}
        format.html { render :action => "new" }
        format.xml  { render :xml => @discount.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /discounts/1
  # PUT /discounts/1.xml
  def update
    @discount = current_user.discounts.find(params[:id])

    respond_to do |format|
      if @discount.update_attributes(params[:discount])
        flash[:notice] = 'Discount was successfully updated.'
        format.html { redirect_to(user_discount_path(current_user,@discount)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @discount.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /discounts/1
  # DELETE /discounts/1.xml
  def destroy
    @discount = current_user.discounts.find(params[:id])
    @discount.destroy

    respond_to do |format|
      format.html { redirect_to(user_discounts_path(current_user)) }
      format.xml  { head :ok }
    end
  end
  
  def close
    @discount = current_user.discounts.find(params[:id]) 
    Discount.transaction do
      @discount.vendors.clear 
      @discount.close!
    end 
    
    respond_to do |format|
      format.html { redirect_to(user_discounts_path(current_user)) }
      format.xml  { head :ok }
    end
  end
  
  def vendor
     @vendor = Vendor.find(pramas[:vendor_id]) 
     #maybe change for order or status
     @discounts = @user.discounts
  end 
  
  private
  
  def find_user
    @user = current_user
  end  
  
end
