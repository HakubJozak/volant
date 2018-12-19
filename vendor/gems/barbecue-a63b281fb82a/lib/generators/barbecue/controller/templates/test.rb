require 'test_helper'

<% module_namespacing do -%>
class <%= controller_class_name %>ControllerTest < ActionController::TestCase
  setup do
    @<%= singular_name %> = create(:<%= singular_name %>)
    sign_in create(:user)
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal 1,json[:<%= plural_name %>].size
  end

  test "create" do
    assert_difference('<%= model_class_name %>.count') do
      post :create, <%= "#{singular_name}: attributes_for(:#{singular_name})" %>

      assert_response :success, response.body.to_s
      assert_not_nil json[:<%=singular_name%>][:id], @<%= singular_name %>.id
    end
  end

  test "update" do
    patch :update, id: <%= "@#{singular_name}, #{singular_name}: attributes_for(:#{singular_name})" %>
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('<%= model_class_name %>.count', -1) do
      delete :destroy, id: <%= "@#{singular_name}" %>
      assert_response :success, response.body.to_s
    end
  end
end
<% end -%>
