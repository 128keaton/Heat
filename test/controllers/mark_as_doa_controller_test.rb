require 'test_helper'

class MarkAsDoaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mark_as_doa_index_url
    assert_response :success
  end

end
