require 'test_helper'

class Public::WorkcampsControllerTest < ActionController::TestCase
  context "Public::WorkcampController" do
    setup do
      20.times { Factory.create(:workcamp) }
    end
    
    should "find all workcamps" do
      get :index
      assert_response :success
    end
  end
end
