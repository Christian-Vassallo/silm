require File.dirname(__FILE__) + '/../test_helper'
require 'merchant_controller'

# Re-raise errors caught by the controller.
class MerchantController; def rescue_action(e) raise e end; end

class MerchantControllerTest < Test::Unit::TestCase
  def setup
    @controller = MerchantController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
