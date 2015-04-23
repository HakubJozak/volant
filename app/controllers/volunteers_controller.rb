class VolunteersController < ApplicationController

  serialization_scope :current_user
  before_action :find_volunteer, only: [ :show, :update, :destroy ]

  def index
    search = Volunteer.order(:lastname,:firstname).page(current_page).per(per_page)

    if q = filter[:q].presence
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
    params.require(:volunteer).except(:age).permit(:firstname, :lastname, :gender,
      :email, :phone,
      :speak_well, :speak_some,
      :passport_expires_at, :passport_issued_at, :passport_number,
      :birthdate, :birthnumber, :birthplace,
      :nationality, :occupation, :account, :emergency_name,
      :emergency_day, :emergency_night,
      :special_needs, :past_experience, :comments,
      :fax, :street, :city, :zipcode,
      :contact_street, :contact_city, :contact_zipcode,
      :note)
  end
end
