class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://www.daorails.com/activate/#{user.activation_code}"
  
  end
  
  def forgot_password(user,password)
    setup_email(user)
    @subject    += 'CY - Reset Password'  
    @body[:password]  = "#{password}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://www.daorails.com/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "support <support@daorails.com>"
      @subject     = "[ASAP]"
      @sent_on     = Time.now
      @body[:user] = user 
      @content_type = "text/html"
    end
end
