# == Schema Information
# Schema version: 20090814063601
#
# Table name: commissions
#
#  id             :integer(4)      not null, primary key
#  booking_id     :integer(4)
#  booking_charge :integer(4)
#  official       :integer(4)
#  user           :integer(4)
#  valid          :boolean(1)
#  created_at     :datetime
#  updated_at     :datetime
#

class Commission < ActiveRecord::Base
end
