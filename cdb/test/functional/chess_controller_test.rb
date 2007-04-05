require File.dirname(__FILE__) + '/../test_helper'
require 'chess_controller'

# Re-raise errors caught by the controller.
class ChessController; def rescue_action(e) raise e end; end

class ChessControllerTest < Test::Unit::TestCase
  fixtures :chess_games

  def setup
    @controller = ChessController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = chess_games(:first).id
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

    assert_not_nil assigns(:chess_games)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:chess_game)
    assert assigns(:chess_game).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:chess_game)
  end

  def test_create
    num_chess_games = ChessGame.count

    post :create, :chess_game => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_chess_games + 1, ChessGame.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:chess_game)
    assert assigns(:chess_game).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ChessGame.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ChessGame.find(@first_id)
    }
  end
end
