require 'test_helper'

class InfosheetsControllerTest < ActionController::TestCase
  context "InfosheetsController" do
    should "not raise exception when record is invalid" do
      post :create, :infosheet => {}
    end
  end
end
