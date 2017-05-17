require 'test_helper'

class SchoolsControllerTest < ActionDispatch::IntegrationTest
  test "create" do
    new_school = School.new
    new_school.name = "Test Academy"
    new_school.quantity = {}
    new_school.school_code = "1738A"
    assert new_school.save
    puts " < - Attempted to create new school: #{new_school.name}"
  end
  test "find" do
    assert_equal "ABC123", schools(:one).school_code
    puts " < - Attempted to find school: #{schools(:one).name}, by code"
  end
end
