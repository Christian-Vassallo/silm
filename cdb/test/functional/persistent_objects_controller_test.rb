require File.dirname(__FILE__) + '/../test_helper'
require 'persistent_objects_controller'

# Re-raise errors caught by the controller.
class PersistentObjectsController; def rescue_action(e) raise e end; end

class PersistentObjectsControllerTest < Test::Unit::TestCase
  fixtures :persistent_objects

  def setup
    @controller = PersistentObjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = persistent_objects(:first).id
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

    assert_not_nil assigns(:persistent_objects)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:persistent_object)
    assert assigns(:persistent_object).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:persistent_object)
  end

  def test_create
    num_persistent_objects = PersistentObject.count

    post :create, :persistent_object => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_persistent_objects + 1, PersistentObject.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:persistent_object)
    assert assigns(:persistent_object).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      PersistentObject.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      PersistentObject.find(@first_id)
    }
  end
end
