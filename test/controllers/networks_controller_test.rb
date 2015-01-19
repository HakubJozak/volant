require 'test_helper'

class NetworksControllerTest < ActionController::TestCase
  setup do
    Network.destroy_all
    @network = Factory(:network)
    sign_in users(:john)
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['networks'].size
  end

  test "create" do
    assert_difference('Network.count') do
      post :create, network: Factory.attributes_for(:network)

      assert_response :success, response.body.to_s
      assert_not_nil json_response['network']['id'], json_response
    end
  end

  test "update" do
    patch :update, id: @network, network: Factory.attributes_for(:network)
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('Network.count', -1) do
      delete :destroy, id: @network
      assert_response :success, response.body.to_s
    end
  end
end
