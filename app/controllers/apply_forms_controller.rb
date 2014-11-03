class ApplyFormsController < ApplicationController

  serialization_scope :current_user
  before_action :find_apply_form, only: [ :show, :update, :destroy, :cancel ]

  def index
    search = Outgoing::ApplyForm.page(current_page).order("#{ApplyForm.table_name}.created_at desc")
    search = search.includes(:payment,:volunteer,:current_workcamp, :current_assignment)
    search = add_year_scope(search)

    if query = params[:q]
      search = search.query(params[:q])
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

  def cancel
    @apply_form.cancel
    render json: @apply_form, serializer: ApplyFormSerializer
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
