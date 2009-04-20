# == Schema Information
# Schema version: 20081223080043
#
# Table name: merchants
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  contact    :string(255)
#  tel        :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  pending    :boolean(1)      default(TRUE)
#

class Merchant < ActiveRecord::Base
  has_many :users
  has_many :vendors
  has_many :discounts, :through => :users 
  
  validates_presence_of :name
  validates_presence_of :contact
  validates_presence_of :tel
  validates_numericality_of :tel
  
  def delete_user(user)
    users.each{ |u| users.delete(u) if u.id.to_s == user }
  end
  
  def delete_vendor(vendor)
    vendors.each{ |v| vendors.delete(v) if v.id.to_s == vendor }         
  end
  
end
