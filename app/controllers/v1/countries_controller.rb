class V1::CountriesController < ApplicationController
  respond_to :json


  def index
    @countries = Country.all
    render json: @countries, each_serializer: V1::CountrySerializer
  end

end
