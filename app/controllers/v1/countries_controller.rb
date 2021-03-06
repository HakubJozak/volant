class V1::CountriesController < V1::BaseController
  respond_to :json

  def index
    @countries = Country.includes(:country_zone).order(:name_en).all
    render json: @countries, each_serializer: V1::CountrySerializer
  end

end
