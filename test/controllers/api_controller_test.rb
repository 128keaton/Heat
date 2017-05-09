require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get hostname" do
    get api_hostname_url
    assert_response :success
  end

  test "should get image" do
    get api_image_url
    assert_response :success
  end

end
