class TagsController < ApplicationController
  respond_to :json

  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /tags
  def index
    @tags = ColoredTag.order(:name).all
    render json: @tags, each_serializer: TagSerializer
  end

  # GET /tags/1
  def show
    render json: @tag, serializer: TagSerializer
  end

  # POST /tags
  def create
    @tag = ColoredTag.new(tag_params)
    if @tag.save
      render json: @tag, serializer: TagSerializer
    else
      render_error(@tag)
    end
  end

  # PATCH/PUT /tags/1
  def update
    if @tag.update(tag_params)
      render json: @tag, serializer: TagSerializer
    else
      render_error(@tag)
    end
  end

  # DELETE /tags/1
  def destroy
    @tag.destroy
    head :no_content
  end

  private

  def set_tag
    @tag = ColoredTag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :color, :text_color, :symbol)
  end
end
