require 'test_helper'

module Incoming
  class WorkcampsControllerTest < ActionController::TestCase

    include ActiveScaffoldCRUDTester

    test "Friday list" do
      get :friday_list_csv
      assert_response :success
    end

    test "participants list" do
      get :participants_csv, :id => item.id
      assert_response :success
    end

    protected

    def item
      Factory.create(:incoming_workcamp)
    end

  end
end
