module Imdb
#  IMDB网站依据下列公式计算每部影片的得分，以排定名次：
#
#  　　加权平均分(WR) = (v ÷ (v+m)) × R + (m ÷ (v+m)) × C
#
#  　　在这里：
#  　　R = 该电影的平均分
#  　　v = 该电影的总投票数
#  　　m = 列入前250所需要的最少票数(目前是1300票)
#  　　C = 数据库中所有电影的总平均分(目前是6.7)
#    加上我们自己打折
# we use this to get rating score
  
# for R
  def avg_score(vendor)
      @avg = ScoreSumary.average(:score, :conditions => ['vendor_id = ?',vendor.id])
  end

#for v
  def total_vote(vendor)
     @total_vote = vendor.reviews_count
  end 
  
#for m  
  def least
     @least = 1.0
  end          
#for C, we should cache it in a configration file  
  def total_avg
     @total_avg = ScoreSumary.common_votes.average(:score)
  end
#计算  
  def imdb_score(vendor) 
    @score = (total_vote(vendor)/vm(vendor))*avg_score(vendor) + (least/vm(vendor))*total_avg
  end
  
  def vm(vendor)
    total_vote(vendor) + least
  end 
  
end    