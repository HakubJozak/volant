class Internal::WorkcampIntentionsController < Internal::BaseController

  include MinimalResponders

  before_action :set_workcamp_intention,
                only: [:show, :edit, :update, :destroy]

  def index
    @intentions = WorkcampIntention.order(:code)
  end

  def new
    @intention = WorkcampIntention.new
  end

  def edit
    render :edit, format: :js, layout: false
  end

  def create
    @intention = WorkcampIntention.new(workcamp_intention_params)
    @intention.save
    respond_with @intention, location: index_path
  end

  def update
    @intention.update(workcamp_intention_params)

    respond_to do |f|
      f.js { render layout: false }
    end
  end

  def destroy
    respond_with @intention.tap(&:destroy), location: index_path
  end

  private

    def set_workcamp_intention
      @intention = WorkcampIntention.find(params[:id])
    end

    def index_path
      internal_workcamp_intentions_path
    end

    def workcamp_intention_params
      params.require(:workcamp_intention).permit(:code, :description_en, :description_cz)
    end
end
