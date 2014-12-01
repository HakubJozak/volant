class V1::WorkcampsController < V1::BaseController
  respond_to :json

  serialization_scope :current_user
  before_action :find_workcamp, only: [ :show ]

  def index
    search = Outgoing::Workcamp.order(:name).page(current_page).live
    search = search.includes(:country,:organization,:tags,:intentions)
    search = add_year_scope(search)

    if query = filter[:q]
      search = search.query(filter[:q])
    end

    if from = filter[:from]
      search = search.where("begin >= ?",Date.parse(from))
    end

    if to = filter[:to]
      search = search.where("\"end\" <= ?",Date.parse(to))
    end

    if md = filter[:min_duration]
      search = search.min_duration(md)
    end

    if md = filter[:max_duration]
      search = search.max_duration(md)
    end

    if ma = filter[:min_age]
      search = search.where("minimal_age >= ?",ma)
    end

    if ma = filter[:max_age]
      search = search.where("maximal_age <= ?",ma)
    end

    if fp = filter[:free]
      search = search.where("free_places >= ?",fp)
    end

    if fp = filter[:free_females]
      search = search.where("free_places_for_females >= ?",fp)
    end

    if fp = filter[:free_males]
      search = search.where("free_places_for_males >= ?",fp)
    end

    if ids = filter[:tag_ids]
      search = search.with_tags(*ids)
    end

    if ids = filter[:workcamp_intention_ids]
      search = search.with_workcamp_intentions(*ids)
    end

    if ids = filter[:country_ids]
      search = search.with_countries(*ids)
    end

    if ids = filter[:organization_ids]
      search = search.with_organizations(*ids)
    end

    render json: search,
           meta: { pagination: pagination_info(search) },
           each_serializer: V1::WorkcampSerializer
  end

  def show
    render json: @workcamp, serializer: V1::WorkcampSerializer
  end

  private

  def filter
    params.permit(:q,:from,:to,:min_duration,:max_duration,:min_age,
                  :max_age,:free,:free_males,:free_females,
                  :tag_ids => [], :country_ids => [], :workcamp_intention_ids => [], :organization_ids => [])
  end

  def find_workcamp
    @workcamp = Outgoing::Workcamp.find(params[:id])
  end

end
