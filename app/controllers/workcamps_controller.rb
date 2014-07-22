class WorkcampsController < ApplicationController

  serialization_scope :current_user

  def index
    current_page = params[:p] || 1
    search = Workcamp.order(:name).page(current_page)

    if query = params[:q]
      wcs = Workcamp.arel_table
      arel = wcs[:name].matches("%#{query}%").or(wcs[:code].matches("%#{query}%"))
      search = search.where(arel)
    end

    if year = params[:year]
      search = search.by_year(year)
    end

    pagination = {
      total: search.total_count,
      total_pages: search.total_pages,
      current_page: current_page
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
      render json: { errors: @workcamp.errors }, status: 422
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
