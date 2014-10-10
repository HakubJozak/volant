class ApplyFormsController < ApplicationController

  serialization_scope :current_user
  before_action :find_apply_form, only: [ :show, :update, :destroy ]

  def index
    search = Outgoing::ApplyForm.order(:created_at).page(current_page)
    search = search.includes(:payment,:volunteer)

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
