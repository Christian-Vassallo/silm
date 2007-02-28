require File.dirname(__FILE__) + '/../test_helper'
require 'set_controller'

# Re-raise errors caught by the controller.
class SetController; def rescue_action(e) raise e end; end

class SetControllerTest < Test::Unit::TestCase
  def setup
    @controller = SetController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
