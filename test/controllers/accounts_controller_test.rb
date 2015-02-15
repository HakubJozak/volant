require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup do
    @account = Factory(:account)
    sign_in users(:john)
  end

  test "update" do
    patch :update, id: @account, account: Factory.attributes_for(:account)
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('Account.count', -1) do
      delete :destroy, id: @account
      assert_response :success, response.body.to_s
    end
  end
end
