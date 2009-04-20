module ReviewsHelper 
  
  def fields_for_rating(rating, &block)
   # prefix = rating.new_record? ? 'new' : 'existing'
    if  rating.new_record?
      fields_for("review[new_rating_attributes][#{rating.vote.id}]", rating, &block)
    else
      fields_for("review[existing_rating_attributes][]", rating, &block)
    end  
  end
  
  def form_ui_for(rating,fomr_builder) 
    case rating.vote.spec    
 		when 1
 		   rating.vote.name + ":" + fomr_builder.select(:score,COMMONOPT) +
 		   fomr_builder.hidden_field(:vote_id) 
     when 2 
       content_tag("p",
 			 rating.vote.name + ":" + fomr_builder.text_field(:score, :size => 10)+
 	  	 fomr_builder.hidden_field(:vote_id)) 
     end
  end

end
