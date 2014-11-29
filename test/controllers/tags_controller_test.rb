require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    ColoredTag.destroy_all
    @tag = Factory(:tag)
    sign_in users(:john)
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['tags'].size
  end

  test "create" do
    assert_difference('ColoredTag.count') do
      post :create, tag: Factory.attributes_for(:tag)

      assert_response :success, response.body.to_s
      assert_not_nil json_response['tag']['id'], json_response
    end
  end

  test "update" do
    patch :update, id: @tag, tag: Factory.attributes_for(:tag)
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('ColoredTag.count', -1) do
      delete :destroy, id: @tag
      assert_response :success, response.body.to_s
    end
  end
end
