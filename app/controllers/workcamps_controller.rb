class WorkcampsController < ApplicationController
  respond_to :json

  serialization_scope :current_user
  before_action :find_workcamp, except: [ :index,:create ]

  def index
    search = workcamps.order(:name).page(current_page)
    search = search.includes(:country,:workcamp_assignments,:organization,:tags,:intentions)
    search = add_year_scope(search)

    if filter[:state]
      search = search.imported_or_updated
    end

    if mode = filter[:publish_mode]
      search = search.where(publish_mode: mode)
    end

    if query = filter[:q]
      search = search.query(filter[:q])
    end

    if filter[:starred]
      search = search.starred_by(current_user)
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

    if ids = filter[:tag_ids].presence
      search = search.with_tags(*ids)
    end

    if ids = filter[:workcamp_intention_ids].presence
      search = search.with_workcamp_intentions(*ids)
    end

    if ids = filter[:country_ids].presence
      search = search.with_countries(*ids)
    end

    if ids = filter[:organization_ids].presence
      search = search.with_organizations(*ids)
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
    @workcamp = workcamps.new(workcamp_params)

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
    head :no_content
  end

  def cancel_import
    @workcamp.cancel_import!
    render json: @workcamp
  end

  def confirm_import
    @workcamp.confirm_import!
    render json: @workcamp
  end


  private

  def find_workcamp
    @workcamp = workcamps.find(params[:id])
  end

  def filter
    params.permit(:starred,:state,:p,:year,:q,:from,:to,:min_duration,:max_duration,:min_age,
                  :max_age,:free,:free_males,:free_females,:publish_mode,
                  :tag_ids => [], :country_ids => [], :workcamp_intention_ids => [], :organization_ids => [])
  end

  # Only allow a trusted parameter "white list" through.
  def workcamp_params
    readonly = [ :state,:free_places,:free_places_for_males,:free_places_for_females, :duration, :tag_list, :sci_id, :sci_code ]

    params.except(*readonly)
      .require(:workcamp)
      .except(*readonly)
      .permit(:name, :code, :language, :begin, :end, :capacity, :minimal_age, :maximal_age,
              :area, :accomodation, :workdesc, :notes, :description, :extra_fee, :extra_fee_currency,
              :region, :capacity_natives, :capacity_teenagers, :capacity_males, :capacity_females,
              :airport, :train, :publish_mode,:places, :places_for_males, :places_for_females,
              :accepted_places, :accepted_places_males, :accepted_places_females,
              :asked_for_places, :asked_for_places_males, :asked_for_places_females,
              :longitude, :latitude, :requirements,
              :organization_id, :country_id, :tag_ids => [], :workcamp_intention_ids => [])
  end

  def workcamps
    case params[:type] || params[:workcamp].try(:[],:type)
    when 'incoming' then Workcamp.where(organization_id: current_organization)
    when 'ltv' then Ltv::Workcamp
    else Workcamp
    end
  end

end
