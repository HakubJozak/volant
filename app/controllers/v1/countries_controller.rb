class V1::CountriesController < V1::BaseController
  respond_to :json


  def index
    @countries = Country.all
    render json: @countries, each_serializer: V1::CountrySerializer
  end

end
