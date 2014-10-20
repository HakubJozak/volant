require 'test_helper'

class EmailContactsControllerTest < ActionController::TestCase

  setup do
    @email_contact = email_contacts(:seeds)
    sign_in users(:john)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:email_contacts)
  end


end
