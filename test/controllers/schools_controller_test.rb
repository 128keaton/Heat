require 'test_helper'

class SchoolsControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get schools_list_url
    assert_response :success
  end

end
