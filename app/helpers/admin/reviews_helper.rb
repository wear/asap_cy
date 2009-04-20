module Admin::ReviewsHelper
  def ratings_column(record)
    record.ratings.collect{|rating| rating.vote.name + ":" + rating.score.to_s}.join(' - ')
  end 
  
  def user_column(record)
    record.user.login
  end
end
