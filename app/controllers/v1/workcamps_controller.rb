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

    case scope = filter[:scope]
    when 'new'
      search = search.future.recently_created
    when 'urgent'
      search = search.future.urgent
    when 'archive'
      search.archive
    when 'all'
      search
    else
      search = search.future
    end

    if from = date_param(:from)
      search = search.where('"begin" >= ?',from)
    end

    if to = date_param(:to)
      search = search.where('"end" <= ?',to)
    end

    if duration = filter[:duration]
      if duration =~ /(\d+)-(\d+)/
        search = search.min_duration($1.to_i)
        search = search.max_duration($2.to_i)
      end
    end

    if people = people_param
      # TODO: move to model
      search = search.where("free_places >= ?",people.count)
      search = search.where("free_places_for_females >= ?",sum_females(people))
      search = search.where("free_places_for_males >= ?",sum_males(people))

      unless ages(people).empty?
        search = search.where("minimal_age <= ?",ages(people).min)
        search = search.where("maximal_age >= ?",ages(people).max)
      end
    end

    if ids = filter[:tag_ids].presence
      search = search.with_tags(*ids)
    end

    if ids = filter[:intent].presence
      search = search.with_workcamp_intentions(*ids)
    end

    if ids = country_ids_param.presence
      search = search.with_countries(*ids)
    end

    if zone = filter[:country_zone_id].presence
      # TODO: move to model
      search = search.joins(:country).where('countries.country_zone_id = ?',zone.to_i)
    end

    if ids = filter[:organization_ids].presence
      search = search.with_organizations(*ids)
    end

    render json: search,
           meta: { pagination: pagination_info(search) },
           each_serializer: V1::WorkcampSerializer
  end

  def short
    search = add_year_scope(workcamps.future)
    render json: search, each_serializer: V1::ShortWorkcampSerializer
  end

  def similar
    # TODO: this scope
    search = @workcamp.class.web_default.future.similar_to(@workcamp).free.limit(10)

    search = add_year_scope(search)
    search = search.includes(:country,:organization,:tags,:intentions)
    render json: search.all, each_serializer: V1::WorkcampSerializer
  end

  def show
    render json: @workcamp, serializer: V1::WorkcampSerializer
  end

  private

  def filter
    params.permit(:q,:scope,:from,:to,:duration,:country_zone_id,
                  :people => [ [:a,:g] ],
                  :vols => [ [:a,:g] ],
                  :tag_ids => [], :country => [],
                  :intent => [], :organization_ids => [])
  end

  def workcamps
    model = case params[:type]
            when 'ltv' then Ltv::Workcamp
            when 'incoming' then Incoming::Workcamp
            else Outgoing::Workcamp
            end

    model.web_default
  end

  def find_workcamp
    @workcamp = Workcamp.find(params[:id])
  end

  def people_param
    if input = filter[:people]
      # it can be hash or array
      array = input.is_a?(Hash) ? input.values : input
      array.select { |p|[ p[:a], p[:g]].any?(&:present?) }
    end
  end

  def country_ids_param
    if ids = filter[:country].presence
      ids.map(&:presence).compact
    end
  end

  def ages(people)
    people.map { |p| p[:a].presence }.compact.map(&:to_i)
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

  def date_param(attr)
    if str = filter[attr].presence
      Date.parse(str)
    end
  rescue ArgumentError
    nil
  end

end
