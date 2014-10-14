require 'test_helper'

class ApplyFormsControllerTest < ActionController::TestCase
  setup do
    @apply_form = Factory(:apply_form)
    sign_in users(:john)
  end

  test "update" do
    patch :update, id: @apply_form.id, apply_form: { motivation: 'endless', general_remarks: 'none' }
    assert_response :success
    assert_equal 'none', json_response['apply_form']['general_remarks']
    assert_equal 'endless', json_response['apply_form']['motivation']
  end

end
