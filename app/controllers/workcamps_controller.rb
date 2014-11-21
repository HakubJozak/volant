class WorkcampsController < ApplicationController
  respond_to :json

  serialization_scope :current_user
  before_action :find_workcamp, only: [ :show, :update, :destroy ]

  def index
    search = Outgoing::Workcamp.order(:name).page(current_page)
    search = search.includes(:country,:workcamp_assignments,:organization,:tags,:intentions)
    search = add_year_scope(search)

    if params[:state]
      search = search.where("state is NOT NULL")
    else
      search = search.where("state is NULL")
    end

    if org = params[:organization_id]
      search = search.where(organization_id: org.to_i)
    end

    if query = params[:q]
      search = search.query(params[:q])
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

    if fp = params[:free]
      search = search.where("free_places >= ?",fp)
    end

    if fp = params[:free_females]
      search = search.where("free_places_for_females >= ?",fp)
    end

    if fp = params[:free_males]
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
    @workcamp = Outgoing::Workcamp.new(workcamp_params)

    if @workcamp.save
      render json: @workcamp, serializer: WorkcampSerializer
    else
      render json: { errors: @workcamp.errors }, status: 422
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
    readonly = [ :state,:free_places,:free_places_for_males,:free_places_for_females, :duration, :tag_list, :sci_id, :sci_code ]
    params.except(*readonly)
      .require(:workcamp)
      .except(*readonly)
      .permit(*WorkcampSerializer.public_attributes)
  end
end
