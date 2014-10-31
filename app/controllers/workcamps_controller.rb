class WorkcampsController < ApplicationController

  serialization_scope :current_user
  before_action :find_workcamp, only: [ :show, :update, :destroy ]

  def index
    search = Outgoing::Workcamp.order(:name).page(current_page)
    search = search.includes(:country,:workcamp_assignments,:organization,:tags,:intentions)

    if query = params[:q]
      search = search.query(params[:q])
    end

    if year = params[:year]
      if year.to_i > 0
        search = search.by_year(year)
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



    render json: search,
           meta: { pagination: pagination_info(search) },
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
