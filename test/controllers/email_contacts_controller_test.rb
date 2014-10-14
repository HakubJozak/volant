require 'test_helper'

class EmailContactsControllerTest < ActionController::TestCase

  setup do
    @email_contact = email_contacts(:one)
    sign_in users(:john)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:email_contacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create email_contact" do
    assert_difference('EmailContact.count') do
      post :create, email_contact: {  }
    end

    assert_redirected_to email_contact_path(assigns(:email_contact))
  end

  test "should show email_contact" do
    get :show, id: @email_contact
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @email_contact
    assert_response :success
  end

  test "should update email_contact" do
    patch :update, id: @email_contact, email_contact: {  }
    assert_redirected_to email_contact_path(assigns(:email_contact))
  end

  test "should destroy email_contact" do
    assert_difference('EmailContact.count', -1) do
      delete :destroy, id: @email_contact
    end

    assert_redirected_to email_contacts_path
  end
end
