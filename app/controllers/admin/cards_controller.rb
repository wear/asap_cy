class Admin::CardsController < ApplicationController
  layout 'admin'
   
  def index
    @cards = Card.find(:all)
  end 
  
  def edit
    @card = Card.find(params[:id])
  end 
  
  def new
    @card = Card.new
  end
  
  def show
   @card = Card.find params[:id] 
  end 
  
  def update
    @card = Card.find(params[:id])

    respond_to do |format|
      if @card.update_attributes(params[:card])
        flash[:notice] = 'Card was successfully updated.'
        format.html { redirect_to(admin_card_path(@card)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def create  
    @card = Card.new(params[:card])
    
    respond_to do |format|
      if @card.save
        flash[:notice] = 'Card was successfully created.'
        format.html { redirect_to(admin_card_path(@card)) }
        format.xml  { render :xml => @card, :status => :created, :location => @card }
      else    
        format.html { render :action => "new" }
        format.xml  { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  def destroy
    @card = Card.find(params[:id])
    @card.destroy

    respond_to do |format|
      format.html { redirect_to(admin_cards_path) }
      format.xml  { head :ok }
    end
  end
  
end
