require 'test_helper'

class CountriesControllerTest < ActionController::TestCase

  setup do
    @country = Factory(:country)
    sign_in users(:john)
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal Country.count,json_response['countries'].size
  end

  test "create" do
    assert_difference('Country.count') do
      post :create, country: Factory.attributes_for(:country)

      assert_response :success, response.body.to_s
      assert_not_nil json_response['country']['id'], json_response
    end
  end

  test "update" do
    patch :update, id: @country, country: Factory.attributes_for(:country)
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('Country.count', -1) do
      delete :destroy, id: @country
      assert_response :success, response.body.to_s
    end
  end
end
