# == Schema Information
# Schema version: 20081223080043
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  login                     :string(40)
#  name                      :string(100)     default("")
#  email                     :string(100)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(40)
#  remember_token_expires_at :datetime
#  activation_code           :string(40)
#  activated_at              :datetime
#  merchant_id               :integer(4)
#  avatar_left               :integer(4)
#  avatar_right              :integer(4)
#  avatar_top                :integer(4)
#  avatar_bottom             :integer(4)
#  mobile                    :string(255)
#

require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken 
  has_many :reviews
   
  has_many :bookings, :as => "bookable"  
  
  has_many :contacts, :as => "contactable"  
  
  has_one :attachment, :as => 'attachable'
  has_many :comments, :through => :reviews
  has_many :points
  has_many :vendors,  :foreign_key => "creator_id" 
  
  validates_presence_of     :login, :email, :mobile
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => "只能为字符,数字和 '.-_@'等符号."

  validates_format_of       :name,     :with => Authentication.name_regex,:message => "只能为字符,数字和 '.-_@'等符号.", :allow_nil => true
  validates_length_of       :name,     :maximum => 100
  
  validates_format_of       :mobile, :with => /^13[0-9]|^15[0-9][0-9]{8}$/, :allow_nil => true
  
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => '必须符合email的格式'
  
  
  before_create :make_activation_code 
  attr_accessor :current_password
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation,:mobile
  has_and_belongs_to_many :roles
  has_many :discounts
  belongs_to :merchant
  
  attr_accessible :avatar_data,:avatar_left,:avatar_right,:avatar_top,:avatar_bottom

  def avatar
    self.attachment.public_filename
  end 
  
  def avatar_data=(data) 
    return if data.blank?
    if attachment
      attachment.update_attributes :uploaded_data => data
    else
      self.attachment = Attachment.create :uploaded_data => data
    end
  end

  def vendor_review(vendor)
     reviews.find_by_vendor_id(vendor)
  end 
  
  def reviewed?(vendor)
     vendor_review(vendor)   
  end
  
  def admin?
    all_roles.include?("admin")
  end
  
  def owner?
    all_roles.include?("owner")
  end
  
  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
#    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u = User.find_user(login)  
    u && u.authenticated?(password) ? u : nil
  end
  
  def self.find_user(coming_item)
    find(:first, :conditions => ['login = ? and activated_at IS NOT NULL', coming_item]) || find(:first, :conditions => ['email = ? and activated_at IS NOT NULL', coming_item]) || find(:first, :conditions => ['mobile = ? and activated_at IS NOT NULL', coming_item])
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def crop_avatar
    return if original_avatar_path.blank?
    
    # crop and resize picture by rmagick
    begin
      original = Magick::Image.read('public' + original_avatar_path)[0]
      picture = original.crop(avatar_left.to_i, avatar_top.to_i, 
                    avatar_bottom.to_i - avatar_top.to_i, avatar_right.to_i - avatar_left.to_i).resize(48, 48)
      picture.write("public" + crop_avatar_path)
    rescue
    end
  end
  
  def original_avatar_path
    original_avatar_exists? ? attachment.public_filename : ''
  end
  
  def original_avatar_exists?
    return false unless attachment
    
    File.exists? "public/#{attachment.public_filename}"
  end
  
  def avatar_exists?
    original_avatar_exists? || crop_avatar_exists?
  end
  
  def avatar_path
    crop_avatar_exists? ? crop_avatar_path : original_avatar_path
  end
  
  def crop_avatar_exists?
    File.file? 'public' + crop_avatar_path
  end
  
  def crop_avatar_path
    @crop_avatar_path ||= File.dirname(original_avatar_path) + '/crop_' + File.basename(original_avatar_path)
  end
  
  def validate
    unless self.mobile.nil? || self.mobile.to_s.size == 11
      errors.add("mobile", "必须是11位")
    end
  end 
  
  def merchant_vendors
    unless merchant.nil? || merchant.vendors.blank?
       merchant.vendors
     end
  end
  
  protected
    
    def make_activation_code
        self.activation_code = self.class.make_token
    end

    def all_roles
      roles.map{|r| r.title}
    end
end
