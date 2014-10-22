require 'test_helper'

class EmailTemplatesControllerTest < ActionController::TestCase
  setup do
    @email_template = Factory(:email_template)
    sign_in users(:john)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['email_templates'].size
  end

  test "should create email_template" do
    assert_difference('EmailTemplate.count') do
      post :create, email_template: Factory.attributes_for(:email_template)

      assert_response :success, response.body.to_s
      assert_not_nil json_response['email_template']['id'], json_response
    end
  end

  test "should update email_template" do
    patch :update, id: @email_template, email_template: Factory.attributes_for(:email_template)
    assert_response :success, response.body.to_s
  end

  test "should destroy email_template" do
    assert_difference('EmailTemplate.count', -1) do
      delete :destroy, id: @email_template
      assert_response :success, response.body.to_s
    end
  end
end
