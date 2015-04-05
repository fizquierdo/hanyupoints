require 'test_helper'
#require 'nokogiri'   
#require 'open-uri'

class HomeFlowTest < ActionDispatch::IntegrationTest
   test "Go to the home page and find a wellcome msg" do
		 get '/'
		 assert_response :success
		 assert_select 'title', 'Wodehanyu'
		 assert_select 'div#main-container', "Let's learn Mandarin 加油!"
		 assert_select 'footer', {count: 1}
		 assert_select 'header', {count: 1}
   end
	 test "Check the content directly with Nokogiri" do
		 page = Nokogiri::HTML(open('http://0.0.0.0:3000/'))
		 assert page.css("div#main-container").css("h1").text.include?("Let's learn Mandarin")
	 end

end
