require 'test_helper'

class FlashcardsControllerTest < ActionController::TestCase
	include Devise::TestHelpers
	include Warden::Test::Helpers

  setup do
		Warden.test_mode!
  end

  test "should not get flashcard if not logged in" do
    get :flashcards
    assert_response :redirect
		assert_redirected_to user_session_path
  end

	# TODO why this does not work?
	# test at the integration level
  #test "should get flashcard if logged in" do
	#	sign_in :one
  #  get :flashcards
  #  assert_response :success
  #end
end
