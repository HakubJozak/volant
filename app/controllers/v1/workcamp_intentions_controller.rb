class V1::WorkcampIntentionsController < V1::BaseController
  def index
    render json: WorkcampIntention.all, each_serializer: V1::WorkcampIntentionSerializer
  end
end
