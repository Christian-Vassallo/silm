require File.dirname(__FILE__) + '/../test_helper'
require 'scene_descriptions_controller'

# Re-raise errors caught by the controller.
class SceneDescriptionsController; def rescue_action(e) raise e end; end

class SceneDescriptionsControllerTest < Test::Unit::TestCase
  fixtures :scene_descriptions

  def setup
    @controller = SceneDescriptionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = scene_descriptions(:first).id
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

    assert_not_nil assigns(:scene_descriptions)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:scene_description)
    assert assigns(:scene_description).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:scene_description)
  end

  def test_create
    num_scene_descriptions = SceneDescription.count

    post :create, :scene_description => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_scene_descriptions + 1, SceneDescription.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:scene_description)
    assert assigns(:scene_description).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      SceneDescription.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      SceneDescription.find(@first_id)
    }
  end
end
