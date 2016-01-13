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

  test 'workcamps_count' do
    create :outgoing_workcamp, publish_mode: 'ALWAYS',
           country: countries(:AT), begin: 5.days.ago
    3.times { create :outgoing_workcamp, publish_mode: 'ALWAYS',
                     country: countries(:AT), begin: 5.days.from_now }
    get :index

    assert_response :success
    at = json[:countries].first
    assert_equal 'Austria', at[:name]
    assert_equal 3, at[:workcamps_count]
  end

  test 'ltv_counts' do
    dummy = create(:outgoing_workcamp, publish_mode: 'ALWAYS',country: countries(:AT))
    free = create(:ltv_workcamp, publish_mode: 'ALWAYS',country: countries(:AT))
    past = create(:ltv_workcamp, publish_mode: 'ALWAYS',
                  country: countries(:AT), begin: 5.days.ago, end: 3.days.ago)
    full = create(:ltv_workcamp, publish_mode: 'ALWAYS',
                  country: countries(:AT))
    full.update_column(:free_places, 0)

    get :index

    assert_response :success
    at = json[:countries].first
    assert_equal 'Austria', at[:name]
    assert_equal 1, at[:ltv_count]
  end
end
