class Internal::WorkcampsController < Internal::BaseController

  before_action :find_workcamp, except: [ :index,:create, :friday_list ]

  def index
    if filter[:starred]
      search = Workcamp.starred_by(current_user)
      render json: search, each_serializer: WorkcampSerializer
    else
      search = apply_filter(workcamps.order(current_order).joins(:country))

      respond_to do |f|
        f.csv  {
          send_data Export::WorkcampCsv.new(search).to_csv, filename: "workcamps.csv"
        }

        f.xml {
          export = Export::PefXml.new(search.all, current_user)
          send_data export.to_xml, filename: export.filename
        }

        f.html {
          @workcamps = search.page(current_page).per(per_page)

          # meta = {
          #   pagination: pagination_info(search),
          #   csv: csv_version(:workcamps_path),
          #   pef: xml_version(:workcamps_path),
          #   friday_list: csv_version(:friday_list_workcamps_path)
          # }

          #render json: search, meta: meta,
          #each_serializer: WorkcampSerializer
        }
      end
    end
  end

  def show
    respond_to do |f|
      f.html {
      }

      f.xml {
        export = Export::PefXml.new(@workcamp, current_user)
        send_data export.to_xml, filename: export.filename
      }
    end
  end

  def create
    @workcamp = workcamps.new(workcamp_params)
    @workcamp.save
    respond_with @workcamp
  end

  def update
    @workcamp.update(workcamp_params)
    respond_with @workcamp
  end

  def destroy
    respond_with @workcamp.tap(&:destroy)
  end

  def participants
    respond_to do |f|
      f.csv {
        send_data Export::Participants.new(@workcamp.apply_forms.accepted.order(:lastname)).to_csv,
        filename: "#{@workcamp.code} - #{@workcamp.name} participants.csv"
      }
    end
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

  # TODO: change to a scope
  def apply_filter(search)
    search = search.includes(:workcamp_assignments,:organization,:tags,:intentions,:organization => [:emails])
    search = search.filter_by_hash(filter,current_user)
    search = add_year_scope(search)
    search
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

  def find_workcamp
    @workcamp = Workcamp.includes(:country,:workcamp_assignments,:organization,:tags,:intentions,:bookings).find(params[:id])
  end

  def workcamps
    type = params[:type] || params[:workcamp].try(:[],:type)

    case type.try(:downcase)
    when 'incoming' then Incoming::Workcamp
    when 'ltv' then Ltv::Workcamp
    when 'outgoing' then Outgoing::Workcamp
    else Workcamp
    end
  end

  def filter
    params.permit(:starred,:state,:p,:order,:year,:q,
                  :from,:to,:min_duration,:max_duration,:age,
                  :free,:free_males,:free_females,:publish_mode,
                  :tag_ids => [],
                  :country_ids => [],
                  :workcamp_intention_ids => [],
                  :organization_ids => [],
                  :ids => [])
  end

  # Only allow a trusted parameter "white list" through.
  def workcamp_params
    readonly = [ :state,
                 :free_places,
                 :free_places_for_males,
                 :free_places_for_females,
                 :tag_list,
                 :sci_id,
                 :sci_code ]

    safe_params = params
                   .except(*readonly)
                   .require(:workcamp)
                   .except(*readonly)
                   .permit(:name, :code, :language, :begin, :end,
                          :capacity,
                          :minimal_age, :maximal_age,
                          :variable_dates,
                          :area, :accommodation, :workdesc,
                          :notes, :description, :extra_fee, :extra_fee_currency,
                          :region,
                          :capacity_natives, :capacity_teenagers,
                          :capacity_males, :capacity_females,
                          :airport, :train, :publish_mode,:places,
                          :places_for_males, :places_for_females,
                          :accepted_places, :accepted_places_males,
                          :accepted_places_females,
                          :asked_for_places, :asked_for_places_males,
                          :asked_for_places_females,
                          :project_summary,
                          :partner_organization,
                          :longitude, :latitude, :requirements, :duration,
                          :organization_id,
                          :country_id,
                          tag_ids: [],
                          workcamp_intention_ids: [])

    replace_nil_by_empty_array(safe_params,:tag_ids)
    replace_nil_by_empty_array(safe_params,:workcamp_intention_ids)

    safe_params
  end

end
