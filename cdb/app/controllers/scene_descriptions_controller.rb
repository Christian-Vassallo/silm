class SceneDescriptionsController < ApplicationController
  before_filter { authenticate(Account::CAN_SET_PERSISTENCY) }

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @show_locked = params['show_locked'] == '1'
    if params['show_locked'] == '1'
      @scene_description_pages, @scene_descriptions = paginate :scene_descriptions,
        :per_page => 100,
        :order => 'pid asc'
    else
      @scene_description_pages, @scene_descriptions = paginate :scene_descriptions,
        :per_page => 100,
        :conditions => ['`locked` = ?', 'false'],
        :order => 'pid asc'
    end
  end

  def show
    @scene_description = SceneDescription.find(params[:id])
  end

  def new
    @scene_description = SceneDescription.new
  end

  def create
    @scene_description = SceneDescription.new(params[:scene_description])
    if @scene_description.save
      flash[:notice] = 'SceneDescription was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @scene_description = SceneDescription.find(params[:id])
  end

  def update
    @scene_description = SceneDescription.find(params[:id])
    if @scene_description.update_attributes(params[:scene_description])
      flash[:notice] = 'SceneDescription was successfully updated.'
      redirect_to :action => 'show', :id => @scene_description
    else
      render :action => 'edit'
    end
  end

  def destroy
    SceneDescription.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
