require 'test_helper'

class StaticControllerTest < ActionController::TestCase
	include Devise::TestHelpers

  setup do
  end

  test "should get home" do
    get :home
    assert_response :success
  end

end
