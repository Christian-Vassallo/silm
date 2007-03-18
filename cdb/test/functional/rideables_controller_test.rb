require File.dirname(__FILE__) + '/../test_helper'
require 'rideables_controller'

# Re-raise errors caught by the controller.
class RideablesController; def rescue_action(e) raise e end; end

class RideablesControllerTest < Test::Unit::TestCase
  fixtures :rideables

  def setup
    @controller = RideablesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = rideables(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:rideables)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:rideable)
    assert assigns(:rideable).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:rideable)
  end

  def test_create
    num_rideables = Rideable.count

    post :create, :rideable => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_rideables + 1, Rideable.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:rideable)
    assert assigns(:rideable).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Rideable.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Rideable.find(@first_id)
    }
  end
end
