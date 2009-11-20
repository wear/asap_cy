# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
   include FaceboxRender
  # render new.rhtml
  def new 
  end  
  
  
  def login_box
     respond_to do |wants|
      wants.html {  }
      wants.js { render_to_facebox }
     end
  end
  
  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      
      respond_to do |wants|
        wants.html {           
           flash[:notice] = "登录成功"    
          if current_user.owner?
               redirect_to user_discounts_path(current_user)
          else
            redirect_back_or_default('/')
          end
           } 
        wants.js { }
      end
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      respond_to do |wants|
        wants.html { render :action => 'new'  } 
        wants.js { render  :template => '/sessions/fail' } 
      end
      
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "你已注销."
    redirect_back_or_default('/')
  end
  
  def mobile
    
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "不能登录为'#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
