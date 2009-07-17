class BookingObserver < ActiveRecord::Observer
  
  def after_create(user)
     Hesine.request(:command => 'Bind',:user_id => user.login,:phone => '+8615001912259',:verify_code => '365922')
  end
  
end
