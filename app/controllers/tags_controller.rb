class TagsController < ApplicationController

  def index
    render json: ColoredTag.all, each_serializer: TagSerializer
  end

  def show
    render json: ColoredTag::Tag.find(params[:id]), serializer: TagSerializer
  end
end
