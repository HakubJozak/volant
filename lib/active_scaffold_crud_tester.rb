module ActiveScaffoldCRUDTester
  
  include ActiveScaffoldReadOnlyTester

  def test_edit
    assert_item_defined
    get :edit, :id => item.id
    assert_response :success
    assert_template 'update.html.erb'
  end

  def test_show
    assert_item_defined
    get :show, :id => item.id
    assert_response :success
    assert_template 'show'
  end

  protected

  def assert_item_defined
    if !self.respond_to?(:item) or self.item.nil?
      fail "define 'item' method for the test class for Admin::ActiveScaffoldCRUDTester"
    end
  end
  
end
