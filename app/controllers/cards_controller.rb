class CardsController < ApplicationController
  def index
     @cards = Card.find :all
  end      
  
  def show
     @card = Card.find(params[:id])
  end
end
