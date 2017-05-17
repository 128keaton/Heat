require 'test_helper'
 
class LoginTest < ActionDispatch::IntegrationTest
  test "can see the welcome page" do
    sign_in users(:one)
    get "/root/index"
    assert_select "p", "Welcome to Heat! Touch any link below to get started!"
    puts " < - Attempted to login, and view the root page"
  end
end