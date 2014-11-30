require 'test_helper'

class ImportChangesControllerTest < ActionController::TestCase
  setup do
    @import_change = Factory(:import_change)
    sign_in users(:john)
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['import_changes'].size
  end

  test "create" do
    assert_difference('ImportChange.count') do
      post :create, import_change: Factory.attributes_for(:import_change)

      assert_response :success, response.body.to_s
      assert_not_nil json_response['import_change']['id'], json_response
    end
  end

  test "update" do
    patch :update, id: @import_change, import_change: Factory.attributes_for(:import_change)
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('ImportChange.count', -1) do
      delete :destroy, id: @import_change
      assert_response :success, response.body.to_s
    end
  end
end
