class CountriesController < ApplicationController
  def index
    orgs = Country.all
    render json: orgs, each_serializer: CountrySerializer
  end

  def show
    render json: Country.find(params[:id])
  end
end
