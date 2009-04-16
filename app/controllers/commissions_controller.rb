class CommissionsController < ApplicationController
  # GET /commissions
  # GET /commissions.xml
  def index
    @commissions = Commission.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @commissions }
    end
  end

  # GET /commissions/1
  # GET /commissions/1.xml
  def show
    @commission = Commission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @commission }
    end
  end

  # GET /commissions/new
  # GET /commissions/new.xml
  def new
    @commission = Commission.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @commission }
    end
  end

  # GET /commissions/1/edit
  def edit
    @commission = Commission.find(params[:id])
  end

  # POST /commissions
  # POST /commissions.xml
  def create
    @commission = Commission.new(params[:commission])

    respond_to do |format|
      if @commission.save
        flash[:notice] = 'Commission was successfully created.'
        format.html { redirect_to(@commission) }
        format.xml  { render :xml => @commission, :status => :created, :location => @commission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @commission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /commissions/1
  # PUT /commissions/1.xml
  def update
    @commission = Commission.find(params[:id])

    respond_to do |format|
      if @commission.update_attributes(params[:commission])
        flash[:notice] = 'Commission was successfully updated.'
        format.html { redirect_to(@commission) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @commission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /commissions/1
  # DELETE /commissions/1.xml
  def destroy
    @commission = Commission.find(params[:id])
    @commission.destroy

    respond_to do |format|
      format.html { redirect_to(commissions_url) }
      format.xml  { head :ok }
    end
  end
end
