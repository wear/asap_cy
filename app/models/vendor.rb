# == Schema Information
# Schema version: 20081223080043
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
  has_many :ratings, :through => :reviews
  has_many :score_sumaries
  belongs_to :discount
  has_many :attachments, :as => 'attachable', :dependent => :destroy
  has_one :vendor_datastamp
          
  validates_presence_of :area
  validates_presence_of :category
  validates_length_of :name, :within => 2..40
  validates_numericality_of :tel1, :allow_nil => true 
  validates_presence_of :address 
  validates_associated :attachments

#  after_save :set_score
#  after_update :set_discount_state
  
#  version_fu
  
  named_scope :lastest_create, :order => 'created_at ASC',:limit => 10
  
  acts_as_ferret :fields => {:name => { :store => :yes },
                             :address => { :store => :yes },               
                             :rating_score => {:index=> :untokenized, :term_vector => :no ,:boost=>30 },
                             :category_name=>{ :store => :yes },
                             :type_name => { :store => :yes },
                             :area_name => { :store => :yes }, 
                             :dish_list => { :store => :yes },
                             :description => { :store => :yes },
                             :tag_list => { :store => :yes },
                             :env => { :index=> :untokenized, :term_vector => :no ,:boost=>5 },
                             :sum => { :index=> :untokenized, :term_vector => :no ,:boost=>5 },
                             :avg => { :index=> :untokenized, :term_vector => :no ,:boost=>5 },
                             :taste => { :index=> :untokenized, :term_vector => :no ,:boost=>5 },
                             :service => { :index=> :untokenized, :term_vector => :no ,:boost=>5 },
                             :discounting => {:index=> :untokenized, :term_vector => :no ,:boost=> 200 }},
                             :ferret => { :analyzer => Analyzer } 
  
  acts_as_taggable_on :tags, :dishes   
    


  def rating_score
    total.score
  end
  
  def discounting
    discount.count unless discount.nil?
  end
  
  def sum
    vote = Vote.find_by_short_name("sum")
    score_sumaries.find_by_vote_id(vote.id).score
  end
  
  def env
    vote = Vote.find_by_short_name("env")
    score_sumaries.find_by_vote_id(vote.id).score
  end
  
  def avg
    vote = Vote.find_by_short_name("avg")
    score_sumaries.find_by_vote_id(vote.id).score
  end
  
  def taste
    vote = Vote.find_by_short_name("taste")
    score_sumaries.find_by_vote_id(vote.id).score
  end
  
  def service
    vote = Vote.find_by_short_name("service")
    score_sumaries.find_by_vote_id(vote.id).score
  end
  
  def category_name
    category.name
  end 
  
  def area_name
     all_area = []
     all_area << area.name
     all_area << area.parent.name
     all_area.uniq.collect{|item| item}.join(" ") 
  end
  
  def caixi
    types.find(:first,:conditions => ["parent_id = ?",1 ])
  end
  
  def avg_price
    types.find(:first,:conditions => ["parent_id = ?",77 ]) 
  end
  
  def type_name
    fetch_all_item(types)
  end

  def sumary_rate
    category.votes.find(:first,:conditions =>[" spec =? ",VOTESPEC['SUM']])
  end
  
  def total_score
     common_rates.map(&:score).inject{|sum,item| sum += item }/common_rates.size
  end
  
  # common vote spec is 1
                      
  def common_rates
     score_sumaries.find(:all,:include => :vote,:conditions =>[" votes.spec =? ",VOTESPEC['COMMON']])
  end
  
  def average
     average = score_sumaries.find(:first,:include => :vote,:conditions =>[" votes.spec =? ",VOTESPEC['AVG']]).score
  end
  
  def total
     total = score_sumaries.find(:first,:conditions => ["vote_id =?", sumary_rate.id])
     if total.nil?
       score_sumaries.create(:score => total_score,:vote => sumary_rate)
     else
       total
     end   
  end       
  
  # find or create the sumary score of the vendor and update it      
  def update_total_score
      d_count = self.discount.nil? ? 0 : self.discount.count/2
      score = imdb_score(self) + d_count
      total.update_attribute(:score,score) 
  end
  
  def update_score_sumary
    disable_ferret(:index_when_finished) do 
      Vote.by_spec(VOTESPEC['COMMON']).each do |v|
        score_sum = ratings.by_vote(v.id).sum("score")
        sumary = score_sumaries.find_by_vote_id(v.id)
        sumary.update_attribute(:score,score_sum) 
      end
      update_total_score
    end
  end 

  def merchant_name
    merchant.nil? ?  '' : merchant.name
  end    
  
  def discount_count
    discount.nil? ? '' : discount.count
  end
  
  def self.full_text_search(q,options,finder_options,sort)
	   return "*" if q.nil? or q == ""
	   sort ||= Ferret::Search::SortField.new(:rating_score ,:type => :float, :reverse => true)
	   default_options = {:per_page => 10, :sort => sort,:lazy => [:name,:address,:category_name,:type_name,:area_name,
    	                                                 :dish_list,:description,:tag_list]}
     
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
   
   def set_score
     if self.score_sumaries.blank?
       self.category.votes.each do |v|
         self.score_sumaries.create(:vote => v, :score => 0)
       end
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
