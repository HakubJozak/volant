require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup do
    @account = create(:account)
    # sign_in users(:john)
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['accounts'].size
  end

  test "create" do
    assert_difference('Account.count') do
      post :create, account: attributes_for(:account)

      assert_response :success, response.body.to_s
      assert_not_nil json_response['account']['id'], json_response
    end
  end

  test "update" do
    patch :update, id: @account, account: attributes_for(:account)
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('Account.count', -1) do
      delete :destroy, id: @account
      assert_response :success, response.body.to_s
    end
  end
end
