class Internal::CountriesController < Internal::BaseController

  include MinimalResponders

  before_action :set_country, only: [:show, :edit, :update, :destroy]

  # GET /countries
  def index
    @countries = Country.joins(:country_zone).includes(:country_zone).order(:name_en).all
  end

  def new
    @country = Country.new
  end

  # POST /countries
  def create
    @country = Country.new(country_params)
    @country.save

    respond_with @country, location: index_path      
  end

  def edit
    render :edit, format: :js, layout: false
  end

  # PATCH/PUT /countries/1
  def update
    @country.update(country_params)
    respond_with @country, location: index_path
  end

  # DELETE /countries/1
  def destroy
    respond_with @country.tap(&:destroy), location: index_path
  end

  private

  def index_path
    internal_countries_path
  end

  def set_country
    @country = Country.find(params[:id])
  end

  def country_params
    params.require(:country).permit(:name_en, :name_cz, :code, :triple_code, :region,:country_zone_id)
  end
end
