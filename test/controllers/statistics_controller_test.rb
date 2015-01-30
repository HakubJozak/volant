require 'test_helper'

class StatisticsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:john)    
  end


  test "should get show" do
    get :show, name: 'outgoing'
    assert_response :success
  end

end
