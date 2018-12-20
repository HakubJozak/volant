class Internal::TagsController < Internal::BaseController
  
  include MinimalResponders

  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  # GET /tags
  def index
    @tags = ColoredTag.order(:name).all
  end

  def new
    @tag = ColoredTag.new
  end

  def edit
    render :edit, format: :js, layout: false
  end

  # POST /tags
  def create
    @tag = ColoredTag.new(tag_params)
    @tag.save
    respond_with @tag, location: index_path
  end

  # PATCH/PUT /tags/1
  def update
    @tag.update(tag_params)
    respond_with @tag, location: index_path
  end

  # DELETE /tags/1
  def destroy
    respond_with @tag.tap(&:destroy), location: index_path
  end

  private
    def index_path
      internal_tags_path
    end

    def set_tag
      @tag = ColoredTag.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:name, :color, :text_color, :symbol)
    end
end
