class Admin::MerchantsController < ApplicationController  
  layout 'admin'
  before_filter :login_required
  before_filter :find_merchant,:except => [:index,:new,:create,:search]
  access_control :DEFAULT => '(admin)'
  
  def index
    @merchants = Merchant.paginate(:all, :page => params[:page])
  end     
  
  def show
  end
  
  def new
    @merchant = Merchant.new
  end
  
  def edit
  end 
  
  def create
    @merchant = Merchant.new(params[:merchant])
    
    respond_to do |wants|
          if @merchant.save
            flash[:notice] =  "商户添加成功"
            wants.html { redirect_to  admin_merchant_path(@merchant) }
          else
            wants.html { render :action => "new" }
          end
    end

  end
  
  def destroy
     @merchant.destroy

     respond_to do |format|
       flash[:notice] =  "商户已删除"  
       format.html { redirect_to(admin_merchants_path) }
       format.xml  { head :ok }
     end
  end
  
  def search
    params[:query] = "*" if params[:query].blank?
    @merchants = Merchant.find(:all, :conditions => "name like '%#{params[:query]}%'")
    respond_to do |wants|
     wants.html { render :action => 'index'}
    end
  end 
  
  def update
   respond_to do |wants|
    if @merchant.update_attributes(params[:merchant])
      flash[:notice] =  "商户已更新" 
      wants.html { redirect_to admin_merchant_path(@merchant) }
    else
      wants.html { render :action => "edit" }
    end
   end
  end
  
  def delete_user
    respond_to do |wants|
      if @merchant.delete_user(params[:user_id]) 
        flash[:notice] =  "商户用户已更新"  
        wants.html { redirect_to admin_merchant_path(@merchant) }
      else
        flash[:notice] =  "商户用户更新出错" 
        wants.html { render :action => "show"}
      end
    end
  end           
  
  def users
    @merchant = Merchant.find(params[:id])        
    @users = User.paginate :all,:include => [:roles],:conditions => " roles.title = 'owner' ",:page => params[:page]  
  end
  
  def vendors
    @merchant = Merchant.find(params[:id])
    @vendors = Vendor.paginate :page => params[:page],:per_page => 15 
  end
  
  def delete_vendor
    respond_to do |wants|
      if @merchant.delete_vendor(params[:vendor_id]) 
        flash[:notice] =  "商户门店已更新"  
        wants.html { redirect_to admin_merchant_path(@merchant) }
      else
        flash[:notice] =  "商户门店更新出错" 
        wants.html { render :action => "show"}
      end
    end
  end
  
  def search_users
    params[:query] = "*" if params[:query].blank?
    @users = User.paginate :all,:include => [:roles],:conditions => " login like '%#{params[:query]}%' and  roles.title = 'owner' ",:page => params[:page]
    respond_to do |wants|
      wants.html { render :action => 'users' }
    end
  end            
  
  def search_vendors
    params[:query] = "*" if params[:query].blank?
    @vendors = Vendor.paginate :all,:conditions => " name like '%#{params[:query]}%'", :page => params[:page]
    respond_to do |wants|
      wants.html { render :action => 'vendors' }
    end
     
  end
  
  protected
  
  def find_merchant
    @merchant = Merchant.find params[:id]
  end
  
end
