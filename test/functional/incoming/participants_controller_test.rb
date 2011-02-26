require 'test_helper'

class Incoming::ParticipantsControllerTest < ActionController::TestCase
  context "ParticipantsController" do
    setup do
      Factory.create(:participant)
      login_as 'admin'
      create_default_organization
    end
    
    should "list all participants" do
      get :index
      assert_response :success
    end
  end
end
