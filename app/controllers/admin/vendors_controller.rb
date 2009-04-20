class Admin::VendorsController < ApplicationController
   layout 'admin'
   before_filter :login_required
   access_control :DEFAULT => '(admin)'
   
   def index 
     build_sort
     @vendors = Vendor.full_text_search('*', {:page => params[:page], :per_page => 10},{},@sort)  
   end
   
   def show
     @vendor = Vendor.find(params[:id]) 

   end
   
   def new
     @vendor = Vendor.new
     @vendor.attachments.build
   end 
   
   def edit
     @vendor = Vendor.find(params[:id]) 
     @tags = @vendor.reviews.tag_counts
     @dishes = @vendor.reviews.dish_counts    
   end 
   
   def pending
     params[:query] = "*" if params[:query].blank?
     @vendors = Vendor.full_text_search(params[:query], {:page => params[:page]}, :conditions => ['pending = ?',true])
     respond_to do |wants|
      wants.html { render :action => 'index'}
     end
   end
   
   def search
     store_location          
     params[:query] = "*" if params[:query].blank?
     @vendors = Vendor.full_text_search(params[:query], {:page => params[:page], :per_page => 10},{},@sort)
     respond_to do |wants|
      wants.html { render :action => 'index'}
     end
   end 
   
   def update 
     @vendor = Vendor.find(params[:id])

     respond_to do |format|
       if @vendor.update_attributes(params[:vendor])
         flash[:notice] = 'Vendor was successfully updated.'
         format.html { redirect_to(admin_vendor_path(@vendor)) }
         format.xml  { head :ok }
       else
         format.html { render :action => "edit" }
         format.xml  { render :xml => @vendor.errors, :status => :unprocessable_entity }
       end
     end
   end

   def create  
     @vendor = Vendor.new(params[:vendor])

     respond_to do |format|
       if @vendor.save
         flash[:notice] = 'Vendor was successfully created.'
         format.html { redirect_to(admin_vendor_path(@vendor)) }
         format.xml  { render :xml => @vendor, :status => :created, :location => @vendor }
       else    
         format.html { render :action => "new" }
         format.xml  { render :xml => @vendor.errors, :status => :unprocessable_entity }
       end
     end
   end


   def destroy
     @vendor = Vendor.find(params[:id])
     @vendor.destroy

     respond_to do |format|
       format.html { redirect_back_or_default(admin_vendors_path) }
       format.xml  { head :ok }
     end
   end
   
end
