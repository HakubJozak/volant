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
      if year.to_i > 0
        search = search.by_year(year)
      else
        render status: :bad_request, body: 'Invalid parameters' and return
      end
    end

    if params[:starred]
      search = search.where(starred: true)
    end

    if from = params[:from]
      search = search.where("begin >= ?",Date.parse(from))
    end

    if to = params[:to]
      search = search.where("\"end\" <= ?",Date.parse(to))
    end

    if md = params[:min_duration]
      search = search.min_duration(md)
    end

    if md = params[:max_duration]
      search = search.max_duration(md)
    end

    if ma = params[:min_age]
      search = search.where("minimal_age >= ?",ma)
    end

    if ma = params[:max_age]
      search = search.where("maximal_age <= ?",ma)
    end

    if fp = params[:free_places]
      search = search.where("free_places >= ?",fp)
    end

    if fp = params[:free_places_for_females]
      search = search.where("free_places_for_females >= ?",fp)
    end

    if fp = params[:free_places_for_males]
      search = search.where("free_places_for_males >= ?",fp)
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
