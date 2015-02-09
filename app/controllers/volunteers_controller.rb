class VolunteersController < ApplicationController

  serialization_scope :current_user
  before_action :find_volunteer, only: [ :show, :update, :destroy ]

  def index
    search = Volunteer.order(:created_at).page(current_page)

    if q = filter[:q]
      search = search.query(q)
    end

    render json: search,
           meta: { pagination: pagination_info(search) },
           each_serializer: VolunteerSerializer
  end

  def update
    if  @volunteer.update(volunteer_params)
      render json: @volunteer, serializer: VolunteerSerializer
    else
      render_error(@volunteer)
    end
  end


  def show
    render json: @volunteer, serializer: VolunteerSerializer
  end

  private

  def find_volunteer
    @volunteer = Volunteer.find(params[:id])
  end

  def filter
    params.permit(:q,:p)
  end

  def volunteer_params
    params.require(:volunteer).except(:age).permit(*VolunteerSerializer.writable)
  end
end
