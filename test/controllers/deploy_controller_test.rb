require 'test_helper'

class DeployControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get deploy_index_url
    assert_response :success
  end

  test "should get assign" do
    get deploy_assign_url
    assert_response :success
  end

end
