require 'test_helper'

class ReceiveControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get receive_index_url
    assert_response :success
  end

  test "should get submit" do
    get receive_submit_url
    assert_response :success
  end

end
