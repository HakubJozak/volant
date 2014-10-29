require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  setup do
    @message = Factory(:message)
    sign_in users(:john)
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['messages'].size
  end

  test "create" do
    assert_difference('Message.count') do
      post :create, message: Factory.attributes_for(:message)

      assert_response :success, response.body.to_s
      assert_not_nil json_response['message']['id']
    end
  end

  test "create with apply_form" do
    assert_difference('Message.count') do
      attrs = Factory.attributes_for(:message)
      form = Factory(:apply_form)
      attrs[:apply_form_id] = form.id
      post :create, message: attrs

      assert_response :success, response.body.to_s
      assert_not_nil json_response['message']['id']
    end
  end

  test "update" do
    patch :update, id: @message, message: Factory.attributes_for(:message)
    assert_response :success, response.body.to_s
  end


  test "show & deliver" do
    get :show, id: @message.id
    assert_nil json_response['message']['sent_at']

    post :deliver, id: @message.id
    assert_response :success, response.body.to_s
    assert_not_nil json_response['message']['sent_at']
  end

  test "destroy" do
    assert_difference('Message.count', -1) do
      delete :destroy, id: @message
      assert_response :success, response.body.to_s
    end
  end
end
