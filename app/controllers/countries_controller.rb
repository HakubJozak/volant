class CountriesController < ApplicationController
  respond_to :json

  before_action :set_country, only: [:show, :edit, :update, :destroy]

  # GET /countries
  def index
    @countries = Country.all
    respond_with(@countries)
  end

  # GET /countries/1
  def show
    respond_with(@country)
  end

  # POST /countries
  def create
    @country = Country.new(country_params)
    @country.save
    respond_with(@country)
  end

  # PATCH/PUT /countries/1
  def update
    @country.update(country_params)
    respond_with(@country)
  end

  # DELETE /countries/1
  def destroy
    @country.destroy
    respond_with(@country)
  end

  private

  def set_country
    @country = Country.find(params[:id])
  end

  def country_params
    params.require(:country).permit(CountrySerializer.public_attributes)
  end
end
