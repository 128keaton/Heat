require 'test_helper'

class FinalizeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get finalize_index_url
    assert_response :success
  end

  test "should get assign" do
    get finalize_assign_url
    assert_response :success
  end

end
