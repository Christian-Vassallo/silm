class RideablesController < ApplicationController
  before_filter() {|c| c.authenticate(Account::CAN_DO_BACKEND) }

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @rideables_pages, @rideables = paginate :rideables, :per_page => 10
  end

  def show
    @rideables = Rideables.find(params[:id])
  end

  def new
    @rideables = Rideables.new
  end

  def create
    @rideables = Rideables.new(params[:rideables])
    if @rideables.save
      flash[:notice] = 'Rideables was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @rideables = Rideables.find(params[:id])
  end

  def update
    @rideables = Rideables.find(params[:id])
    if @rideables.update_attributes(params[:rideables])
      flash[:notice] = 'Rideables was successfully updated.'
      redirect_to :action => 'show', :id => @rideables
    else
      render :action => 'edit'
    end
  end

  def destroy
    Rideables.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
