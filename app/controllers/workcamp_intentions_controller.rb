class WorkcampIntentionsController < ApplicationController
  respond_to :json

  before_action :set_workcamp_intention, only: [:show, :edit, :update, :destroy]

  # GET /workcamp_intentions
  def index
    @workcamp_intentions = WorkcampIntention.order(:code)
    render json: @workcamp_intentions, each_serializer: WorkcampIntentionSerializer
  end

  # GET /workcamp_intentions/1
  def show
    render json: @workcamp_intention, serializer: WorkcampIntentionSerializer
  end

  # POST /workcamp_intentions
  def create
    @workcamp_intention = WorkcampIntention.new(workcamp_intention_params)
    if @workcamp_intention.save
      render json: @workcamp_intention, serializer: WorkcampIntentionSerializer
    else
      render json: { errors:  @workcamp_intention.errors }, status: 422
    end
  end

  # PATCH/PUT /workcamp_intentions/1
  def update
    if @workcamp_intention.update(workcamp_intention_params)
      render json: @workcamp_intention, serializer: WorkcampIntentionSerializer
    else
      render json: { errors:  @workcamp_intention.errors }, status: 422
    end
  end

  # DELETE /workcamp_intentions/1
  def destroy
    @workcamp_intention.destroy
    head :no_content
  end

  private

  def set_workcamp_intention
    @workcamp_intention = WorkcampIntention.find(params[:id])
  end

  def workcamp_intention_params
    params.require(:workcamp_intention).permit(:code, :description_en, :description_cz)
  end
end
