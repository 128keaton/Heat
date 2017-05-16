require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers
    test "login" do
        assert sign_in users(:one)
    end
end
