class UsersController < ApplicationController  
  before_filter :login_required, :except => [:create,:activate,:new,:profile ]
  before_filter :assign_user,:except => [:create,:activate,:new,:show ]

  def show
    store_location
    @user = current_user 
    respond_to do |wants|
      wants.html { }
    end
  end
  
  def profile
    @user = User.find(params[:id])
    @reviews = @user.reviews.paginate :page => params[:page], :per_page => 50   
    respond_to do |wants|
      wants.html {}  
    end
  end

   
  def new 
    @user = User.new 
    respond_to do |wants|
      wants.html { render :layout => 'application' }
    end
  end
  
  def bookings
    @bookings = @user.bookings.paginate :page => params[:page], :order => 'created_at DESC' 
  end
  
  def update
    respond_to do |wants|              
    if @user.update_attributes(params[:user])
       @user.crop_avatar
        flash[:notice] = "更新成功."
        wants.html { redirect_back_or_default(@user) }
      else
        wants.html { render :action => "setting" }
      end
    end
  end
  
  def avatar
    store_location
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      flash[:notice] = "多谢您的注册!我们已向您的邮箱发送确认邮件,请注意查收！." 
      redirect_to '/login' 
    else
      render :action => 'new',:layout => 'application'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "注册完成! 您现在就可以登录了."
    when params[:activation_code].blank?
      flash[:error] = "验证码缺失.请使用确认邮件中的url地址."
    else 
      flash[:error]  = "此验证码无效,请检查确认邮件,或者重新注册?."
    end
    redirect_to '/login'
  end
  
  def password
  end
  
  def change_password
     respond_to do |format|
       if User.authenticate(@user.login, params[:user][:current_password])
 	      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
 	      flash[:notice] = "密码修改成功！"
 	      format.html { redirect_to user_path(@user) }
 	     else
 	      format.html { render :action => 'password' }
 	    end
      else
 	     @user.errors.add_to_base("现密码不正确")
 	     format.html { render :action => 'password' }
      end
    end
  end
  
  protected
    def assign_user
      @user = current_user
    end
end
