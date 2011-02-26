require 'test_helper'

class VisibilityControllerTest < ActionController::TestCase

  def setup
    login_as('admin')
  end

  test "show and hide something" do
    xhr :post, :hide_menu_item, :id => 'test_id'
    assert assigns(:hcart).hidden?('test_id')

    xhr :post, :show_menu_item, :id => 'test_id'
    assert assigns(:hcart).visible?('test_id')
  end
end
