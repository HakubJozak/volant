class Internal::WorkcampIntentionsController < Internal::BaseController

  include MinimalResponders

  before_action :set_workcamp_intention,
                only: [:show, :edit, :update, :destroy]

  # GET /workcamp_intentions
  def index
    @workcamp_intentions = WorkcampIntention.order(:code)
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
      render_error(@workcamp_intention)
    end
  end

  # PATCH/PUT /workcamp_intentions/1
  def update
    @workcamp_intention.update(workcamp_intention_params)
    respond_with @workcamp_intention
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
