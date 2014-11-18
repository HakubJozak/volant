class V1::WorkcampsController < ApplicationController
  respond_to :json

  serialization_scope :current_user
  before_action :find_workcamp, only: [ :show ]

  def index
    search = Outgoing::Workcamp.order(:name).page(current_page)
    search = search.includes(:country,:workcamp_assignments,:organization,:tags,:intentions)
    search = add_year_scope(search)

    if query = params[:q]
      search = search.query(params[:q])
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
           each_serializer: V1::WorkcampSerializer
  end

  def show
    render json: @workcamp, serializer: V1::WorkcampSerializer
  end

  private

  def find_workcamp
    @workcamp = Outgoing::Workcamp.find(params[:id])
  end

end
