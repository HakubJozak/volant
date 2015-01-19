require 'test_helper'

class V1::CountriesControllerTest < ActionController::TestCase
  test 'index' do
    Factory(:outgoing_workcamp, publish_mode: 'ALWAYS',country: countries(:AT))

    get :index
    
    assert_response :success
    json = json_response['countries'].first
    assert_equal 'Austria', json['name']
    assert_equal 1, json['workcamps_count']
    assert_equal 0, json['ltv_count']        
    assert_equal 'Europe Western',json['country_zone_name']
  end
end
