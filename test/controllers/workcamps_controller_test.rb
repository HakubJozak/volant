require 'test_helper'

class WorkcampsControllerTest < ActionController::TestCase
  setup do
    @workcamp = Factory(:workcamp)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should show workcamp" do
    get :show, id: @workcamp
    assert_response :success
  end


  test "should update workcamp" do
    patch :update, id: @workcamp, workcamp: { name: 'edited', code: 'new-code' }
    assert_response :success
    assert_equal 'edited', json_response['workcamp']['name']
    assert_equal 'new-code', json_response['workcamp']['code']
  end

  test "should destroy workcamp" do
    assert_difference('Workcamp.count', -1) do
      delete :destroy, id: @workcamp
    end

    assert_redirected_to workcamps_path
  end

end
