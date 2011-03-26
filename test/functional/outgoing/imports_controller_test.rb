require 'test_helper'

class Outgoing::ImportsControllerTest < ActionController::TestCase

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should import WCs" do
    # assert_difference('Outgoing::Import.count') do
    #   post :create, :import => { }
    # end
    # assert_redirected_to import_path(assigns(:import))
  end

  test "should show import result" do
    # get :show, :id =>
    # assert_response :success
  end

end
