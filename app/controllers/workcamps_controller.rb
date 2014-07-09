class WorkcampsController < ApplicationController

  serialization_scope :current_user

  def index
    search = Workcamp.order(:name).page(params[:p])

    if query = params[:q]
      like = Workcamp.arel_table[:name].matches("%#{query}%")
      search = search.where(like)
    end

    pagination = {
      total: search.total_count,
      total_pages: search.total_pages,
      pages: (1..search.total_pages).to_a
    }

    render json: search,
           meta: { pagination: pagination },
           each_serializer: WorkcampSerializer
  end

  def show
    render json: Workcamp.find(params[:id]), serializer: WorkcampSerializer
  end

  # POST /workcamps
  def create
    @workcamp = Workcamp.new(workcamp_params)

    if @workcamp.save
      redirect_to @workcamp, notice: 'Workcamp was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /workcamps/1
  def update
    if  Workcamp.find(params[:id]).update(workcamp_params)
      redirect_to @workcamp, notice: 'Workcamp was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    Workcamp.find(params[:id]).destroy
    redirect_to workcamps_url, notice: 'Workcamp was successfully destroyed.'
  end

  private

  # Only allow a trusted parameter "white list" through.
  def workcamp_params
    params[:workcamp]
  end
end
