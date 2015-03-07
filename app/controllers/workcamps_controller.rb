class WorkcampsController < ApplicationController
  respond_to :json

  serialization_scope :current_user
  before_action :find_workcamp, except: [ :index,:create ]

  def index
    if ids = filter[:ids]
      search = Workcamp.includes(:country,:workcamp_assignments,:organization,:tags,:intentions)
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
    when 'code' then "code #{current_order_direction}"
    when 'from' then "\"begin\" #{current_order_direction}"
    when 'to' then "\"end\" #{current_order_direction}"
    when 'country'then "countries.name_en #{current_order_direction}"
    else "name #{current_order_direction}"
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
    if @workcamp.update(workcamp_params)
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
    @workcamp = Workcamp.find(params[:id])
  end

  def workcamps
    type = params[:type] || params[:workcamp].try(:[],:type)
    workcamp_type(type)
  end
  
  def filter
    params.permit(:starred,:state,:p,:order,:year,:q,:from,:to,:min_duration,:max_duration,:age,
                  :free,:free_males,:free_females,:publish_mode,
                  :tag_ids => [], :country_ids => [],
                  :workcamp_intention_ids => [], :organization_ids => [],
                  :ids => [])
  end

  # Only allow a trusted parameter "white list" through.
  def workcamp_params
    readonly = [ :state,:free_places,:free_places_for_males,:free_places_for_females, :tag_list, :sci_id, :sci_code ]

    safe_params = params.except(*readonly)
      .require(:workcamp)
      .except(*readonly)
      .permit(:name, :code, :language, :begin, :end, :capacity, :minimal_age, :maximal_age,
              :area, :accomodation, :workdesc, :notes, :description, :extra_fee, :extra_fee_currency,
              :region, :capacity_natives, :capacity_teenagers, :capacity_males, :capacity_females,
              :airport, :train, :publish_mode,:places, :places_for_males, :places_for_females,
              :accepted_places, :accepted_places_males, :accepted_places_females,
              :asked_for_places, :asked_for_places_males, :asked_for_places_females,
              :longitude, :latitude, :requirements, :duration,
              :organization_id, :country_id, :tag_ids => [], :workcamp_intention_ids => [])

    # HACK - dealing with [] being converted to nil Rails behaviour
    safe_params[:tag_ids] = [] if safe_params[:tag_ids].nil?
    safe_params[:workcamp_intention_ids] = [] if safe_params[:workcamp_intention_ids].nil?    
    safe_params
  end

end
