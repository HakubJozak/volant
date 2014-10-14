require 'test_helper'

class CountriesControllerTest < ActionController::TestCase
  setup do
    sign_in users(:john)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
