class WorkcampIntentionsController < ApplicationController
  def index
    render json: WorkcampIntention.all, each_serializer: WorkcampIntentionSerializer
  end

  def show
    render json: WorkcampIntention.find(params[:id])
  end

end
