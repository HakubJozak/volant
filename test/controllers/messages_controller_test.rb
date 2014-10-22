require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  setup do
    @message = Factory(:message)
    sign_in users(:john)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['messages'].size
  end

  test "should create message" do
    assert_difference('Message.count') do
      post :create, message: { body: @message.body, from: @message.from, subject: @message.subject, to: @message.to }
      assert_response :success, response.body.to_s
      assert_equal 1, json_response['messages'].size
    end
  end

  test "should update message" do
    patch :update, id: @message, message: {}
    assert_response :success, response.body.to_s
  end

  test "should destroy message" do
    assert_difference('Message.count', -1) do
      delete :destroy, id: @message
      assert_response :success, response.body.to_s
    end
  end
end
