require 'test_helper'

class BookingsControllerTest < Base
  setup do
    @booking = Factory(:booking)
    sign_in Factory(:user)
  end

  test "index" do
    get :index, ids: [@booking.id]
    assert_response :success
    assert_equal 1,json[:bookings].size
  end

  test "create" do
    assert_difference('Booking.count') do
      wc = Factory(:workcamp)
      country = Factory(:country)      
      attrs = Factory.attributes_for(:booking).merge(workcamp_id: wc.id,country_id: country.id)
      post :create, booking: attrs

      assert_response :success, response.body.to_s
      assert_not_nil json[:booking][:id], @booking.id
    end
  end

  test "update" do
    patch :update, id: @booking, booking: Factory.attributes_for(:booking)
    assert_response :success, response.body.to_s
  end

  test "destroy" do
    assert_difference('Booking.count', -1) do
      delete :destroy, id: @booking
      assert_response :success, response.body.to_s
    end
  end
end
