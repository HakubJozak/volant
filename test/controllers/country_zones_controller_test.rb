require 'test_helper'

class CountryZonesControllerTest < ActionController::TestCase
  setup do
    @country_zone = Factory(:country_zone)
    sign_in users(:john)
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['country_zones'].size
  end

  test "create" do
    assert_difference('CountryZone.count') do
      post :create, country_zone: Factory.attributes_for(:country_zone)

      assert_response :success, response.body.to_s
      assert_not_nil json_response['country_zone']['id'], json_response
    end
  end

  test "update" do
    patch :update, id: @country_zone, country_zone: Factory.attributes_for(:country_zone)
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('CountryZone.count', -1) do
      delete :destroy, id: @country_zone
      assert_response :success, response.body.to_s
    end
  end
end
