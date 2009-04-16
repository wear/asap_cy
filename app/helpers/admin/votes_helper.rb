module Admin::VotesHelper 
  def spec_form_column(record, input_name)
    select :record, :spec, VOTESPEC 
  end
end
