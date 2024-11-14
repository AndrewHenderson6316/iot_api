require "test_helper"

class Api::V1::IotDataControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_iot_data_create_url
    assert_response :success
  end
end
