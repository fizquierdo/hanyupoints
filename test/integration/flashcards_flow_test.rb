require 'test_helper'

class FlashcardsFlowTest < ActionDispatch::IntegrationTest
   test "login and play the flashcards" do

		 # visit the flashcards page but cant get there
		 get "/flashcards"
		 assert_response :redirect

		 # go to the sing_in page
		 get "/users/sign_in"
		 assert_response :success
		 assert_equal '/users/sign_in', path

		 # TODO there seem to be problemas with devise and integration testing
		 #      so we will not test here further for now, come back in a while
		 #      https://github.com/plataformatec/devise/issues/3475
		 ## Login (lets assume the user had been created)
		 #User.create!(email: "dummy@home.com", password: "dummyismypass")
		 #post_via_redirect '/users/sign_in', {"user[email]" => "dummy@home.com", "user[password]" =>  "dummyismypass"}
		 #assert_equal '/flashcards', path
   end
end
