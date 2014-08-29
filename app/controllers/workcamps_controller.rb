class WorkcampsController < ApplicationController

  serialization_scope :current_user
  before_action :find_workcamp, only: [ :show, :update, :destroy ]

  def index
    current_page = params[:p] || 1
    search = Outgoing::Workcamp.order(:name).page(current_page)

    if query = params[:q]
      wcs = Outgoing::Workcamp.arel_table
      arel = wcs[:name].matches("%#{query}%").or(wcs[:code].matches("%#{query}%"))
      search = search.where(arel)
    end

    if year = params[:year]
      search = search.by_year(year)
    end

    pagination = {
      total: search.total_count,
      total_pages: search.total_pages,
      current_page: current_page
    }

    render json: search,
           meta: { pagination: pagination },
           each_serializer: WorkcampSerializer
  end

  def show
    render json: @workcamp, serializer: WorkcampSerializer
  end

  # POST /workcamps
  def create
    @workcamp = Workcamp.new(workcamp_params)

    if @workcamp.save
      redirect_to @workcamp, notice: 'Workcamp was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /workcamps/1
  def update
    if  @workcamp.update(workcamp_params)
      render json: @workcamp, serializer: WorkcampSerializer
    else
      render json: { errors: @workcamp.errors }, status: 422
    end
  end

  def destroy
    @workcamp.destroy
    redirect_to workcamps_url, notice: 'Workcamp was successfully destroyed.'
  end

  private

  def find_workcamp
    @workcamp = Workcamp.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def workcamp_params
    params.except(:state,:free_places,:free_places_for_males,:free_places_for_females)
      .require(:workcamp)
      .permit(*WorkcampSerializer.public_attributes)
  end
end
