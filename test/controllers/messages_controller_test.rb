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
    end

    assert_response :success
    assert_equal 1, json_response['messages'].size
  end

  test "should show message" do
    get :show, id: @message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @message
    assert_response :success
  end

  test "should update message" do
    patch :update, id: @message, message: { body: @message.body, from: @message.from, subject: @message.subject, to: @message.to }
    assert_redirected_to message_path(assigns(:message))
  end

  test "should destroy message" do
    assert_difference('Message.count', -1) do
      delete :destroy, id: @message
    end

    assert_redirected_to messages_path
  end
end
