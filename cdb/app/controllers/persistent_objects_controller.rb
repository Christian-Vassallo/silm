class PersistentObjectsController < ApplicationController
  before_filter {|c| c.authenticate(Account::CAN_SET_PERSISTENCY) }

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }

  def list
    cond_str = '1=1'
    cond = []
        
    @filter_str = params['filter_str'] || session['po_filter'] || 'blut bloodstain knochen move_'
    session['po_filter'] = params['filter_str'] if params['filter_str'] 

    @filter_str.split(/\s+/).map {|x| x.gsub(/[^a-z]/i, "")}.each {|x|
      cond_str += ' and resref not like ? '
      cond << '%' + x + '%'
    }
    @persistent_object_pages, @persistent_objects = paginate :persistent_objects, 
      :conditions => [cond_str].concat(cond), 
      :per_page => 100
  end

  def show
    @persistent_object = PersistentObject.find(params[:id])
  end

  def new
    @persistent_object = PersistentObject.new
  end

  def create
    @persistent_object = PersistentObject.new(params[:persistent_object])
    if @persistent_object.save
      flash[:notice] = 'PersistentObject was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @persistent_object = PersistentObject.find(params[:id])
  end

  def update
    @persistent_object = PersistentObject.find(params[:id])
    if @persistent_object.update_attributes(params[:persistent_object])
      flash[:notice] = 'PersistentObject was successfully updated.'
      redirect_to :action => 'show', :id => @persistent_object
    else
      render :action => 'edit'
    end
  end

  def destroy
    PersistentObject.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
