class TagsController < ApplicationController
  respond_to :json

  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /tags
  def index
    @tags = Tag.order(:name)
    respond_with(@tags)
  end

  # GET /tags/1
  def show
    respond_with(@tag)
  end

  # POST /tags
  def create
    @tag = Tag.new(tag_params)
    @tag.save
    respond_with(@tag)
  end

  # PATCH/PUT /tags/1
  def update
    @tag.update(tag_params)
    respond_with(@tag)
  end

  # DELETE /tags/1
  def destroy
    @tag.destroy
    head :no_content
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(TagSerializer.writable)
  end
end
