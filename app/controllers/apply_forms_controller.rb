class ApplyFormsController < ApplicationController

  serialization_scope :current_user
  before_action :find_apply_form, only: [ :show, :update, :destroy ]

  def index
    current_page = params[:p] || 1
    search = Outgoing::ApplyForm.order(:created_at).page(current_page)

    pagination = {
      total: search.total_count,
      total_pages: search.total_pages,
      current_page: current_page
    }

    render json: search,
           meta: { pagination: pagination },
           each_serializer: ApplyFormSerializer
  end

  def show
    render json: @apply_form, serializer: ApplyFormSerializer
  end

  private

  def find_apply_form
    @apply_form = ApplyForm.find(params[:id])
  end


end
