require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:john)
    @account = Account.current
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['accounts'].size
  end

  test "update" do
    patch :update, id: @account, account: Factory.attributes_for(:account)
    assert_response :success, response.body.to_s
  end


end
