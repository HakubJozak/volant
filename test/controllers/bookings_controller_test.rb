require 'test_helper'

class BookingsControllerTest < ActionController::TestCase
  setup do
    @booking = create(:booking)
    sign_in create(:user)
  end

  test "index" do
    get :index
    assert_response :success
    assert_equal 1,json[:bookings].size
  end

  test "create" do
    assert_difference('Booking.count') do
      post :create, booking: attributes_for(:booking)

      assert_response :success, response.body.to_s
      assert_not_nil json[:booking][:id], @booking.id
    end
  end

  test "update" do
    patch :update, id: @booking, booking: attributes_for(:booking)
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('Booking.count', -1) do
      delete :destroy, id: @booking
      assert_response :success, response.body.to_s
    end
  end
end
