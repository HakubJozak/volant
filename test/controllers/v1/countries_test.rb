require 'test_helper'

class V1::CountriesControllerTest < ActionController::TestCase
  test 'index' do
    get :index
    assert_response :success
    json = json_response['countries'].first
    assert_equal 'Austria', json['name']
    assert_equal 'Europe Western',json['country_zone_name']
  end
end
