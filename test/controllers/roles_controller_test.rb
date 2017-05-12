require 'test_helper'

class RolesControllerTest < ActionDispatch::IntegrationTest
  test "create" do
    hash =  {"cpu" => "AMD Junk", "ram" => "256", "hdd" => "10000"}
    new_role = Role.new
    # mmmm rolls
    new_role.suffix = "T"
    # mista t
    new_role.name ="Teacher"
    new_role.specs = hash
    assert new_role.save!
  end
  
  test "find" do
    assert_equal "T", Role.where(name: "Teacher")[0].suffix
  end

end
