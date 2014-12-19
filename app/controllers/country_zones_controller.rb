class CountryZonesController < ApplicationController
  respond_to :json

  before_action :set_country_zone, only: [:show, :edit, :update, :destroy]

  # GET /country_zones
  def index
    @country_zones = CountryZone.all
    render json: @country_zones, each_serializer: CountryZoneSerializer
  end

  # GET /country_zones/1
  def show
    render json: @country_zone, serializer: CountryZoneSerializer
  end

  # POST /country_zones
  def create
    @country_zone = CountryZone.new(country_zone_params)
    if @country_zone.save
      render json: @country_zone, serializer: CountryZoneSerializer
    else
      render json: { errors:  @country_zone.errors }, status: 422
    end
  end

  # PATCH/PUT /country_zones/1
  def update
    if @country_zone.update(country_zone_params)
      render json: @country_zone, serializer: CountryZoneSerializer
    else
      render json: { errors:  @country_zone.errors }, status: 422
    end
  end

  # DELETE /country_zones/1
  def destroy
    @country_zone.destroy
    head :no_content
  end

  private

  def set_country_zone
    @country_zone = CountryZone.find(params[:id])
  end

  def country_zone_params
    params.require(:country_zone).permit(*CountryZoneSerializer.writable)
  end
end
