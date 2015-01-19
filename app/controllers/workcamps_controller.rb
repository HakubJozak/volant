class WorkcampsController < ApplicationController
  respond_to :json

  serialization_scope :current_user
  before_action :find_workcamp, except: [ :index,:create ]

  def index
    if ids = filter[:ids]
      search = workcamps.includes(:country,:workcamp_assignments,:organization,:tags,:intentions)
      render json: search.find(*ids), each_serializer: WorkcampSerializer
    else
      search = workcamps.order(current_order).page(current_page).joins(:country)
      search = search.includes(:workcamp_assignments,:organization,:tags,:intentions)
      search = search.filter_by_hash(filter,current_user)
      search = add_year_scope(search)
      render json: search, meta: { pagination: pagination_info(search) }, each_serializer: WorkcampSerializer
    end
  end

  def current_order
    case filter[:order].presence
    when 'code' then :code
    when 'from' then :'begin'
    when 'to' then :'end'
    when 'country'then 'countries.name_en'
    else :name
    end
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
      render_error(@workcamp)
    end
  end

  def update
    if  @workcamp.update(workcamp_params)
      render json: @workcamp, serializer: WorkcampSerializer
    else
      render_error(@workcamp)
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
    params.permit(:starred,:state,:p,:order,:year,:q,:from,:to,:min_duration,:max_duration,:min_age,
                  :max_age,:free,:free_males,:free_females,:publish_mode,
                  :tag_ids => [], :country_ids => [],
                  :workcamp_intention_ids => [], :organization_ids => [],
                  :ids => [])
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
