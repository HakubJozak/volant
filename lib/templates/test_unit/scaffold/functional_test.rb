require 'test_helper'

<% module_namespacing do -%>
class <%= controller_class_name %>ControllerTest < ActionController::TestCase
  setup do
    @<%= singular_table_name %> = Factory(:<%= singular_table_name %>)
    sign_in users(:john)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['<%= plural_table_name %>'].size
  end

  test "should create <%= singular_table_name %>" do
    assert_difference('<%= class_name %>.count') do
      post :create, <%= "#{singular_table_name}: { #{attributes_hash} }" %>
      assert_response :success, response.body.to_s
      assert_equal 1, json_response['<%= plural_table_name %>'].size
    end
  end

  test "should update <%= singular_table_name %>" do
    patch :update, id: <%= "@#{singular_table_name}" %>, <%= "#{singular_table_name}: {}" %>
    assert_response :success, response.body.to_s
  end

  test "should destroy <%= singular_table_name %>" do
    assert_difference('<%= class_name %>.count', -1) do
      delete :destroy, id: <%= "@#{singular_table_name}" %>
      assert_response :success, response.body.to_s
    end
  end
end
<% end -%>