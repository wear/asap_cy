class ForumsController < ApplicationController
  # GET /forums
  # GET /forums.xml
  def index
    @forums = Forums.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forums }
    end
  end

  # GET /forums/1
  # GET /forums/1.xml
  def show
    @forums = Forums.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @forums }
    end
  end

  # GET /forums/new
  # GET /forums/new.xml
  def new
    @forums = Forums.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @forums }
    end
  end

  # GET /forums/1/edit
  def edit
    @forums = Forums.find(params[:id])
  end

  # POST /forums
  # POST /forums.xml
  def create
    @forums = Forums.new(params[:forums])

    respond_to do |format|
      if @forums.save
        flash[:notice] = 'Forums was successfully created.'
        format.html { redirect_to(@forums) }
        format.xml  { render :xml => @forums, :status => :created, :location => @forums }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forums.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forums/1
  # PUT /forums/1.xml
  def update
    @forums = Forums.find(params[:id])

    respond_to do |format|
      if @forums.update_attributes(params[:forums])
        flash[:notice] = 'Forums was successfully updated.'
        format.html { redirect_to(@forums) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forums.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.xml
  def destroy
    @forums = Forums.find(params[:id])
    @forums.destroy

    respond_to do |format|
      format.html { redirect_to(forums_url) }
      format.xml  { head :ok }
    end
  end
end
