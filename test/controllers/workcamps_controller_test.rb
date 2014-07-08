require 'test_helper'

class WorkcampsControllerTest < ActionController::TestCase
  setup do
    @workcamp = workcamps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workcamps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create workcamp" do
    assert_difference('Workcamp.count') do
      post :create, workcamp: {  }
    end

    assert_redirected_to workcamp_path(assigns(:workcamp))
  end

  test "should show workcamp" do
    get :show, id: @workcamp
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @workcamp
    assert_response :success
  end

  test "should update workcamp" do
    patch :update, id: @workcamp, workcamp: {  }
    assert_redirected_to workcamp_path(assigns(:workcamp))
  end

  test "should destroy workcamp" do
    assert_difference('Workcamp.count', -1) do
      delete :destroy, id: @workcamp
    end

    assert_redirected_to workcamps_path
  end
end
