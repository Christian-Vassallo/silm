class RideablesController < ApplicationController
  before_filter() {|c| c.authenticate(Account::CAN_SEE_RIDEABLES) }
  before_filter(:only => %w{create edit update destroy} ) {|c| c.authenticate(Account::CAN_EDIT_RIDEABLES) }

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @rideable_pages, @rideables = paginate :rideables, :per_page => 10
  end

  def show
    @rideable = Rideable.find(params[:id])
  end

  def new
    @rideable = Rideable.new
  end

  def create
    @rideable = Rideable.new(params[:rideable])
    if @rideable.save
      flash[:notice] = 'Rideable was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @rideable = Rideable.find(params[:id])
  end

  def update
    @rideable = Rideable.find(params[:id])
    if @rideable.update_attributes(params[:rideable])
      flash[:notice] = 'Rideable was successfully updated.'
      redirect_to :action => 'show', :id => @rideable
    else
      render :action => 'edit'
    end
  end

  def destroy
    Rideable.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
