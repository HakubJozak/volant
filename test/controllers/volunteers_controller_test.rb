require 'test_helper'

class VolunteersControllerTest < ActionController::TestCase
  setup do
    @volunteer = Factory(:volunteer)
  end


  test "update" do
    patch :update, id: @volunteer.id, volunteer: { firstname: 'Krystof Harant', age: 33}
    assert_response :success
    assert_equal 'Krystof Harant', json_response['volunteer']['firstname']
    assert_not_equal 33, json_response['volunteer']['age'].to_i
  end

end
