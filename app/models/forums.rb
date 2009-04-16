# == Schema Information
# Schema version: 20081223080043
#
# Table name: forums
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  parent_id   :integer(4)
#  order       :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class Forums < ActiveRecord::Base
  has_many :topics
end
