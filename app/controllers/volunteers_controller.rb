class VolunteersController < ApplicationController

  serialization_scope :current_user
  before_action :find_volunteer, only: [ :show, :update, :destroy ]

  def index
    current_page = params[:p] || 1
    search = Volunteer.order(:created_at).page(current_page)

    pagination = {
      total: search.total_count,
      total_pages: search.total_pages,
      current_page: current_page
    }

    render json: search,
           meta: { pagination: pagination },
           each_serializer: VolunteerSerializer
  end

  def show
    render json: @volunteer, serializer: VolunteerSerializer
  end

  private

  def find_volunteer
    @volunteer = Volunteer.find(params[:id])
  end


end
