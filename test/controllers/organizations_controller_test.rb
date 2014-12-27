require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  setup do
    Organization.destroy_all
    @organization = Factory(:organization)
    sign_in users(:john)
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal 1,json_response['organizations'].size
  end

  test "index with pagination" do
    get :index, p: 1, q: @organization.name[0..2]
    assert_response :success
    assert_equal 1,json_response['organizations'].size
  end


  test "create" do
    assert_difference('Organization.count') do
      country = Factory(:country)

      post :create, organization: Factory.attributes_for(:organization).merge(country_id: country.id)

      assert_response :success, response.body.to_s
      assert_not_nil json_response['organization']['id'], json_response
    end
  end

  test "update" do
    patch :update, id: @organization, organization: Factory.attributes_for(:organization)
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('Organization.count', -1) do
      delete :destroy, id: @organization.id
      assert_response :success, response.body.to_s
    end
  end
end
