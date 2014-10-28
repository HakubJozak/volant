require 'test_helper'

<% module_namespacing do -%>
class <%= controller_class_name %>ControllerTest < ActionController::TestCase
  setup do
    @<%= singular_table_name %> = Factory(:<%= singular_table_name %>)
    sign_in users(:john)
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['<%= plural_table_name %>'].size
  end

  test "create" do
    assert_difference('<%= class_name %>.count') do
      post :create, <%= "#{singular_table_name}: Factory.attributes_for(:#{singular_table_name})" %>

      assert_response :success, response.body.to_s
      assert_not_nil json_response['<%= singular_table_name %>']['id'], json_response
    end
  end

  test "update" do
    patch :update, id: <%= "@#{singular_table_name}, #{singular_table_name}: Factory.attributes_for(:#{singular_table_name})" %>
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('<%= class_name %>.count', -1) do
      delete :destroy, id: <%= "@#{singular_table_name}" %>
      assert_response :success, response.body.to_s
    end
  end
end
<% end -%>
