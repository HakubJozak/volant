require 'test_helper'

class WorkcampIntentionsControllerTest < ActionController::TestCase
  setup do
    @workcamp_intention = Factory(:workcamp_intention)
    sign_in users(:john)
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['workcamp_intentions'].size
  end

  test "create" do
    assert_difference('WorkcampIntention.count') do
      post :create, workcamp_intention: Factory.attributes_for(:workcamp_intention)

      assert_response :success, response.body.to_s
      assert_not_nil json_response['workcamp_intention']['id'], json_response
    end
  end

  test "update" do
    patch :update, id: @workcamp_intention, workcamp_intention: Factory.attributes_for(:workcamp_intention)
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('WorkcampIntention.count', -1) do
      delete :destroy, id: @workcamp_intention
      assert_response :success, response.body.to_s
    end
  end
end
