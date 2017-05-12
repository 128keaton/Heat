require 'test_helper'

class ReceiveControllerTest < ActionDispatch::IntegrationTest
  test "find" do
    assert_equal "abc1234", machines(:one).serial_number
  end
  test "create" do
    updated_machine = Machine.new
    updated_machine.serial_number = "URADOOD"
    updated_machine.role = roles(:one)
    assert updated_machine.save!
  end
end
