require 'test_helper'

class SchoolsControllerTest < ActionDispatch::IntegrationTest
  test "find" do
    assert_equal "ABC123", schools(:one).school_code
  end
  test "create" do
    new_school = School.new
    new_school.school_code = "1738A"
    assert new_school.save
  end
end
