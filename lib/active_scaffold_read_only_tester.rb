require 'test_helper'

module ActiveScaffoldReadOnlyTester
  
  def setup
    login_as 'admin'
    create_default_organization
  end
  
  def test_index
    assert_item_defined
    get :index, :language_code => 'cs'
    assert_response :success
    assert_template 'list'
  end

  def test_show
    assert_item_defined
    get :show, :id => item.id, :language_code => 'cs'
    assert_response :success
    assert_template 'show'
  end

  def assert_item_defined
    fail "define 'item' method for the test class for Admin::ActiveScaffoldReadOnlyTester" unless self.respond_to? :item
  end
  
end
