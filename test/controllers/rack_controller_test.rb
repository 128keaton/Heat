require 'test_helper'

class RackControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rack_index_url
    assert_response :success
  end

  test "should get assign" do
    get rack_assign_url
    assert_response :success
  end

end
