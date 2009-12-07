# == Schema Information
# Schema version: 20090814063601
#
# Table name: vendors
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  address       :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  description   :text
#  nearby        :string(255)
#  alias         :string(255)
#  tel1          :integer(4)
#  tel2          :integer(4)
#  area_id       :integer(4)
#  category_id   :integer(4)
#  reviews_count :integer(4)      default(0)
#  merchant_id   :integer(4)
#  discount_id   :integer(4)
#  pending       :boolean(1)      default(TRUE)
#  creator_id    :integer(4)
#  author_id     :integer(4)
#  version       :integer(4)      default(1)
#

class Vendor < ActiveRecord::Base
  include Imdb
  belongs_to :area, :counter_cache => true
  belongs_to :category
  has_and_belongs_to_many :types
  

  belongs_to :merchant
  has_many :bookings
  has_many :reviews
  has_many :score_sumaries
  belongs_to :discount
  has_many :attachments, :as => 'attachable', :dependent => :destroy
  has_one :vendor_datastamp
          

#  after_save :set_score
#  after_update :set_discount_state
  
#  version_fu
  
  named_scope :lastest_create, :order => 'created_at ASC',:limit => 10
  
#  acts_as_ferret :fields => {:name => { :store => :yes },
#                             :address => { :store => :yes },               
#                             :rating_score => {:index=> :untokenized, :term_vector => :no ,:boost=>30 },
#                             :category => { :store => :yes },
#                             :tags => { :store => :yes },
#                             :env => { :index=> :untokenized, :term_vector => :no ,:boost=>5 },
#                             :sum => { :index=> :untokenized, :term_vector => :no ,:boost=>5 },
#                             :avg => { :index=> :untokenized, :term_vector => :no ,:boost=>5 },
#                             :taste => { :index=> :untokenized, :term_vector => :no ,:boost=>5 },
#                             :service => { :index=> :untokenized, :term_vector => :no ,:boost=>5 },
#                             :discounting => {:index=> :untokenized, :term_vector => :no ,:boost=> 200 }},
#                             :ferret => { :analyzer => Analyzer } 
  
   
  default_scope :order => 'sum'
  
  def merchant_name
    merchant.nil? ?  '' : merchant.name
  end    
  
  def discount_count
    discount.nil? ? '' : discount.count
  end
  
  def self.full_text_search(q,options,finder_options,sort)
	   return "*" if q.nil? or q == ""
	   sort ||= Ferret::Search::SortField.new(:rating_score ,:type => :float, :reverse => true)
	   default_options = {:per_page => 10, :sort => sort,
	                      :lazy => [:name,:address,:tagst]}
     
	   options.reverse_merge!(default_options)
     Vendor.find_with_ferret(q,options,finder_options)
  end
  
  #for image uoload
  after_update :save_attachments
  
  def new_attachment_attributes=(attachment_attributes)
    attachment_attributes.each do |attributes|
      attachments.build(attributes)
    end
  end
  
  def existing_attachment_attributes=(attachment_attributes)
    attachment_attributes.each do |attributes|
      attachment = attachments.detect { |t| t.id == attributes[:id].to_i }
      if attachment && attributes.should_destroy.to_i == 1
       attachments.delete(attachment)
      end
    end
  end
  

  def save_attachments
    attachments.each do |t|
#      if t.should_destroy?
#        t.destroy
#      else
        t.save(false)
#      end
    end
  end
   
   
   def set_discount_state
      unless discount.nil?
        discount.use!
      end
   end                   
   
   protected
   
   def fetch_all_item(objs)
     all_obj = []
     objs.each do |obj|
       all_obj << obj.parent.name
       all_obj << obj.name
     end
     all_obj.uniq.collect{|item| item}.join(" ")
   end  
   
end
