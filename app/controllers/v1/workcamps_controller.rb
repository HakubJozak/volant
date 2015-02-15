class V1::WorkcampsController < V1::BaseController
  respond_to :json

  serialization_scope :current_user
  before_action :find_workcamp, only: [ :show, :similar ]

  def index
    search = workcamps.page(current_page)
    search = add_year_scope(search)
    search = search.includes(:country,:organization,:tags,:intentions)

    if query = filter[:q]
      search = search.query(filter[:q])
    end

    if scope = filter[:scope]
      # TODO: move to model
      if scope == 'new'
        search = search.where('workcamps.created_at > ?',7.days.ago)
      elsif scope == 'urgent'
        search = search.where('free_places > 0 AND "begin" >= current_date AND "begin" <= ?',14.day.from_now)
      end
    end

    if from = filter[:from]
      search = search.where('"begin" >= ?',Date.parse(from))
    end

    if to = filter[:to]
      search = search.where('"end" <= ?',Date.parse(to))
    end

    if md = filter[:min_duration]
      search = search.min_duration(md)
    end

    if md = filter[:max_duration]
      search = search.max_duration(md)
    end

    if people = filter[:people]
      # TODO: move to model
      search = search.where("free_places >= ?",people.count)
      search = search.where("free_places_for_females >= ?",sum_females(people))
      search = search.where("free_places_for_males >= ?",sum_males(people))

      unless ages(people).empty?
        search = search.where("minimal_age <= ?",ages(people).min)
        search = search.where("maximal_age >= ?",ages(people).max)
      end
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

    if zone = filter[:country_zone_id]
      # TODO: move to model
      search = search.joins(:country).where('countries.country_zone_id = ?',zone.to_i)
    end

    if ids = filter[:organization_ids]
      search = search.with_organizations(*ids)
    end

    render json: search,
           meta: { pagination: pagination_info(search) },
           each_serializer: V1::WorkcampSerializer
  end

  def short
    search = add_year_scope(search)
    render json: workcamps, each_serializer: V1::ShortWorkcampSerializer
  end

  def similar
    search = workcamps.similar_to(@workcamp).limit(10)
    search = add_year_scope(search)
    search = search.includes(:country,:organization,:tags,:intentions)
    render json: search, each_serializer: V1::WorkcampSerializer
  end

  def show
    render json: @workcamp, serializer: V1::WorkcampSerializer
  end

  private

  def filter
    params.permit(:q,:scope,:from,:to,:min_duration,:max_duration,:country_zone_id,
                  :people => [ [:a,:g] ],
                  :tag_ids => [], :country_ids => [],
                  :workcamp_intention_ids => [], :organization_ids => [])
  end

  def workcamps
    model = case params[:type]
            when 'ltv' then Ltv::Workcamp
            when 'incoming' then Incoming::Workcamp
            else Outgoing::Workcamp
            end
    model.order(:name).live.published(Account.current.season_start)
  end

  def find_workcamp
    @workcamp = Workcamp.find(params[:id])
  end

  def short_list
    params[:short].present?
  end

  def ages(people)
    people.map { |p| p[:a].try(:to_i) }.compact
  end

  def sum_males(people)
    sum(people,'m')
  end

  def sum_females(people)
    sum(people,'f')
  end

  def sum(people,gender)
    people.inject(0) { |sum,person| sum + (person[:g].to_s.downcase == gender ? 1 : 0) }
  end


end
