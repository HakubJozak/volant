class ApplyFormsController < ApplicationController

  serialization_scope :current_user
  before_action :find_apply_form, only: [ :show, :update, :destroy ]

  def index
    dir = params[:asc] ? :asc : :desc

    search = Outgoing::ApplyForm.page(current_page).order(created_at: dir)
    search = search.includes(:payment,:volunteer,:current_workcamp, :current_assignment)

    if params[:sort]
      case params[:sort].to_sym
      when :created_at
        search.order(created_at: dir)
      when :name
        search.order("volunteers.lastname #{dir}, volunteers.firstname #{dir}").order(created_at: dir)
      end
    end

    if year = params[:year]
      if year.to_i > 0
        search = search.year(year)
      else
        render status: :bad_request, body: 'Invalid parameters' and return
      end
    end

    render json: search,
           meta: { pagination: pagination_info(search) },
           each_serializer: ApplyFormSerializer
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
    params.require(:apply_form).permit(:starred, :general_remarks, :motivation, :volunteer_id, :cancelled, :confirmed, :fee)
  end

end
