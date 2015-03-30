require 'test_helper'

class V1::CountriesControllerTest < ActionController::TestCase
  test 'index' do
    free = Factory(:outgoing_workcamp, publish_mode: 'ALWAYS',country: countries(:AT))
    full = Factory(:outgoing_workcamp, publish_mode: 'ALWAYS',country: countries(:AT))
    full.update_column(:free_places, 0)

    get :index

    assert_response :success
    json = json_response['countries'].first
    assert_equal 'Austria', json['name']
    assert_equal 1, json['workcamps_count']
    assert_equal 0, json['ltv_count']
    assert_equal 'Europe Western',json['country_zone_name']
  end

  test 'ltv_counts' do
    dummy = Factory(:outgoing_workcamp, publish_mode: 'ALWAYS',country: countries(:AT))
    free = Factory(:ltv_workcamp, publish_mode: 'ALWAYS',country: countries(:AT))
    full = Factory(:ltv_workcamp, publish_mode: 'ALWAYS',country: countries(:AT))
    full.update_column(:free_places, 0)

    get :index

    assert_response :success
    json = json_response['countries'].first
    assert_equal 'Austria', json['name']
    assert_equal 1, json['ltv_count']
  end
end
