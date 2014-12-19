class CountriesController < ApplicationController
  respond_to :json

  before_action :set_country, only: [:show, :edit, :update, :destroy]

  # GET /countries
  def index
    @countries = Country.all
    render json: @countries, each_serializer: CountrySerializer
  end

  # GET /countries/1
  def show
    render json: @country, serializer: CountrySerializer
  end

  # POST /countries
  def create
    @country = Country.new(country_params)
    if @country.save
      render json: @country, serializer: CountrySerializer
    else
      render json: { errors:  @country.errors }, status: 422
    end
  end

  # PATCH/PUT /countries/1
  def update
    if @country.update(country_params)
      render json: @country, serializer: CountrySerializer
    else
      render json: { errors:  @country.errors }, status: 422
    end
  end

  # DELETE /countries/1
  def destroy
    @country.destroy
    head :no_content
  end

  private

  def set_country
    @country = Country.find(params[:id])
  end

  def country_params
    params.require(:country).permit(:name_en, :name_cz, :code, :triple_code, :region,:country_zone_id)
  end
end
