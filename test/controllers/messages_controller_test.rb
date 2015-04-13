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

  test 'index with user_id' do
    u1,u2 = 2.times.map { Factory(:user) }
    @message.update_attribute(:user,u1)

    get :index, user_id: u1.id
    assert_response :success
    assert_equal 1,json_response['messages'].size

    get :index, user_id: u2.id
    assert_response :success
    assert_equal 0,json_response['messages'].size
  end

  test "create" do
    assert_difference('Message.count') do
      post :create, message: Factory.attributes_for(:message)

      assert_response :success, response.body.to_s
      assert_not_nil json_response['message']['id']
    end
  end

  test "create infosheet_all" do
    assert_difference('Message.count') do
      post :create, message: Factory.attributes_for(:message).merge(action: 'incoming/infosheet_all')
      assert_response :success, response.body.to_s
      assert_not_nil json_response['message']['id']
    end
  end

  test "create with apply_form" do
    assert_difference('Message.count') do
      attrs = Factory.attributes_for(:message)
      form = Factory(:apply_form)
      # regression - should not fail for invalid applications
      form.update_column(:motivation,nil)
      attrs[:apply_form_id] = form.id

      post :create, message: attrs

      assert_response :success, response.body.to_s
      assert_not_nil json_response['message']['id']
    end
  end

  test 'create with VEF attachment' do
    assert_difference('Message.count') do
      attrs = Factory.attributes_for(:message)
      form = Factory(:apply_form)
      attrs[:attachments] = [{ type: 'VefXmlAttachment', apply_form_id: form},
                             { type: 'VefHtmlAttachment', apply_form_id: form},
                             { type: 'VefPdfAttachment', apply_form_id: form}]

      post :create, message: attrs

      assert_not_nil id = json_response['message']['id']
      assert_not_nil saved = Message.find(id)
      assert_equal form.id, saved.attachments.first.apply_form.id

      assert_equal 3, saved.attachments.size
      assert_equal [VefXmlAttachment,VefHtmlAttachment,VefPdfAttachment], saved.attachments.map(&:class)
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

  test 'deliver' do
    form = Factory(:paid_form)
    form.update_column(:motivation,nil)
    @message.update_attribute(:apply_form,form)

    post :deliver, id: @message.id

    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('Message.count', -1) do
      delete :destroy, id: @message
      assert_response :success, response.body.to_s
    end
  end
end
