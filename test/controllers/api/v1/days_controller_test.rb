require 'test_helper'

class Api::V1::DaysControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_v1_days_show_url
    assert_response :success
  end

end
