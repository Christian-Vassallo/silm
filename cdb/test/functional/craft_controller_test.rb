require File.dirname(__FILE__) + '/../test_helper'
require 'craft_controller'

# Re-raise errors caught by the controller.
class CraftController; def rescue_action(e) raise e end; end

class CraftControllerTest < Test::Unit::TestCase
  def setup
    @controller = CraftController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
