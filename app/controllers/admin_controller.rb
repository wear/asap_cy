class AdminController < ApplicationController 
  before_filter :login_required 
  access_control :DEFAULT => '(admin | owner)'
  
  def index
    @vendor_count = Vendor.count_by_sql('select count(*) from vendors')
    @merchant_count = Merchant.count_by_sql('select count(*) from merchants')  
  end
  
  def setting
    
  end
  
end
