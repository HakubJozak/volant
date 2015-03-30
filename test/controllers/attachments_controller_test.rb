require 'test_helper'

class AttachmentsControllerTest < ActionController::TestCase
  setup do
    @attachment = Factory(:file_attachment)
    sign_in users(:john)
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['attachments'].size
  end

  test "create" do
    assert_difference('Attachment.count') do
      post :create, attachment: Factory.attributes_for(:file_attachment)

      assert_response :success, response.body.to_s
      assert_not_nil json_response['attachment']['id'], json_response
    end
  end

  test "update" do
    patch :update, id: @attachment, attachment: Factory.attributes_for(:file_attachment)
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('Attachment.count', -1) do
      delete :destroy, id: @attachment
      assert_response :success, response.body.to_s
    end
  end
end
