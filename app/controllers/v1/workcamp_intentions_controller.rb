class V1::WorkcampIntentionsController < ApplicationController
  def index
    render json: WorkcampIntention.all, each_serializer: V1::WorkcampIntentionSerializer
  end
end
