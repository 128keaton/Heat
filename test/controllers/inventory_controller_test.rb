require 'test_helper'

class InventoryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get inventory_index_url
    assert_response :success
  end

  test "should get add" do
    get inventory_add_url
    assert_response :success
  end

  test "should get remove" do
    get inventory_remove_url
    assert_response :success
  end

  test "should get find" do
    get inventory_find_url
    assert_response :success
  end

end
