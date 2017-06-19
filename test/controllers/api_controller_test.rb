require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
    test "hostname-api" do
        # define variables
        school = schools(:two)
        role = roles(:one)
        machine = machines(:one)
        created_hostname = "#{school[:school_code]}#{role[:suffix]}BL-#{machine[:serial_number]}"

        # feeling testy?
        assert_equal "DORAMETBL-abc1234", created_hostname
        puts(" < - Attempted to check serial: #{created_hostname}")
    end

    test "imagename-api" do
        school = schools(:two)
        role = roles(:one)
        if school[:blended_learning] && school[:blended_learning] == true
            image_name = "blended_learning/#{ role.name.downcase }"
			assert_equal "blended_learning/teacher", image_name
            puts " < - Attempted to test image-name: #{image_name}"
		else
            image_name = "standard/#{role.name.downcase}"
			assert_equal "standard/teacher", image_name
            puts " < - Attempted to test image-name: #{image_name}"
		end
    end

    test "set-asset-tag" do
        machine = machines(:one)
        machine.update(client_asset_tag: "qwerty")
        assert machine.save
        assert_equal Machine.where(client_asset_tag: "qwerty").count, 1
        puts " < - Attempted to check machine count. Machine count with asset tag 'qwerty': #{Machine.where(client_asset_tag: "qwerty").count}. Expected 1"
    end
end
