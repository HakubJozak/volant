class ApplyFormsController < ApplicationController

  serialization_scope :current_user
  before_action :find_apply_form, only: [ :show, :update, :destroy, :cancel ]

  def index
    search = Outgoing::ApplyForm.page(current_page).order("#{ApplyForm.table_name}.created_at desc")
    search = search.joins(:current_workcamp,:current_assignment)
    search = search.includes(:volunteer)
    search = add_year_scope(search)

    if filter[:starred]
      search = search.where(starred: true)
    end

    if query = filter[:q]
      search = search.query(filter[:q])
    end

    if state = filter[:state]
      # TODO: put those inside model
      case state
      when 'on_project'
        today = Date.today
        search = search.where("workcamps.begin <= ? AND workcamps.end >= ?",today,today)
        search = search.where('workcamp_assignments.accepted IS NOT NULL and cancelled IS NULL ')
      when 'without_payment'
        search = search.joins('left outer join payments on payments.apply_form_id = apply_forms.id').state_filter(state)
      else
        search = search.state_filter(state)
      end
    end

    # dir = params[:asc] ? :asc : :desc
    # if params[:sort]
    #   case params[:sort].to_sym
    #   when :created_at
    #     search.order(created_at: dir)
    #   when :name
    #     search.order("volunteers.lastname #{dir}, volunteers.firstname #{dir}").order(created_at: dir)
    #   end
    # end
    render json: search,
           meta: { pagination: pagination_info(search) },
           each_serializer: ApplyFormSerializer
  end

  def destroy
    @apply_form.destroy
    head :no_content
  end

  def cancel
    @apply_form.cancel
    render json: @apply_form, serializer: ApplyFormSerializer
  end

  def create
    @apply_form = Outgoing::ApplyForm.new(apply_form_params)

    if @apply_form.save
      render json: @apply_form, serializer: ApplyFormSerializer
    else
      render json: { errors: @apply_form.errors }, status: 422
    end
  end

  def update
    if  @apply_form.update(apply_form_params)
      render json: @apply_form, serializer: ApplyFormSerializer
    else
      render json: { errors: @apply_form.errors }, status: 422
    end
  end


  def show
    render json: @apply_form, serializer: ApplyFormSerializer
  end

  private

  def find_apply_form
    @apply_form = ApplyForm.find(params[:id])
  end

  def apply_form_params
    params.require(:apply_form).permit(:starred, :general_remarks, :motivation, :volunteer_id, :cancelled, :confirmed, :fee,
                                       payment_attributes: PaymentSerializer.writable, volunteer_attributes: VolunteerSerializer.writable)
  end

  def filter
    params.permit(:starred,:q,:state,:p,:year)
  end

end
