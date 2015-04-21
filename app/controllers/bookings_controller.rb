class BookingsController < ApplicationController
  respond_to :json

  before_action :find_booking, except: [:index,:create]

  # GET /bookings
  def index
    if ids = params.permit(ids: [])[:ids]
      bookings = Booking.find(ids)
      render json: bookings, each_serializer: BookingSerializer
    else
      raise 'Cannot retrieve all bookings.'
    end
  end

  # GET /bookings/1
  def show
    render json: @booking, serializer: BookingSerializer
  end

  # POST /bookings
  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      render json: @booking, serializer: BookingSerializer
    else
      render json: { errors:  @booking.errors }, status: 422
    end
  end

  # PATCH/PUT /bookings/1
  def update
    if @booking.update(booking_params)
      render json: @booking, serializer: BookingSerializer
    else
      render json: { errors:  @booking.errors }, status: 422
    end
  end

  # DELETE /bookings/1
  def destroy
    @booking.destroy
    if wc = @booking.workcamp
      render json: wc.reload, serializer: WorkcampSerializer
    else
      head :no_content
    end
  end

  private

  def find_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:expires_at,:country_id,:organization_id,:gender,:workcamp_id)
  end
end
