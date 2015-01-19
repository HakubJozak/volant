class NetworksController < ApplicationController
  respond_to :json

  before_action :find_network, except: [:index,:create]

  # GET /networks
  def index
    @networks = Network.all
    render json: @networks, each_serializer: NetworkSerializer
  end

  # GET /networks/1
  def show
    render json: @network, serializer: NetworkSerializer
  end

  # POST /networks
  def create
    @network = Network.new(network_params)
    if @network.save
      render json: @network, serializer: NetworkSerializer
    else
      render json: { errors:  @network.errors }, status: 422
    end
  end

  # PATCH/PUT /networks/1
  def update
    if @network.update(network_params)
      render json: @network, serializer: NetworkSerializer
    else
      render json: { errors:  @network.errors }, status: 422
    end
  end

  # DELETE /networks/1
  def destroy
    @network.destroy
    head :no_content
  end

  private

  def find_network
    @network = Network.find(params[:id])
  end

  def network_params
    params.require(:network).permit(:name,:web)
  end
end
