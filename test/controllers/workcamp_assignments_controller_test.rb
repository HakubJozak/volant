require 'test_helper'

class WorkcampAssignmentsControllerTest < ActionController::TestCase
  setup do
    @wa = Factory(:workcamp_assignment)
    sign_in users(:john)
  end

  test "update" do
    put :update, id: @wa.id, workcamp_assignment: { order: 666, accepted: '2014-03-07' }

    assert_response :success
    json = json_response['workcamp_assignment']
    assert_equal 666,json['order']
    assert_equal '2014-03-07T00:00:00.000Z',json['accepted']
    assert_equal 'accepted', json['state']
    assert_equal 'accepted', json_response['apply_forms'].first['state']['name']
  end

  # test "should get create" do
  #   get :create
  #   assert_response :success
  # end

  test "should get destroy" do
    delete :destroy, id: @wa.id
    assert_response :success
  end

end
