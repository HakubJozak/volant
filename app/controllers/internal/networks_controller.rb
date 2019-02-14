class Internal::NetworksController < Internal::BaseController
  include MinimalResponders

  before_action :find_network, only: [:edit, :update, :destroy]

  # GET /networks
  def index
    @networks = Network.order(:name).page(current_page)
  end

  def new
    @network = Network.new
  end

  # POST /networks
  def create
    @network = Network.new(network_params)
    @network.save
    respond_with @network, location: index_path
  end

  # PATCH/PUT /networks/1
  def update
    @network.update(network_params)
    respond_with @network, location: index_path
  end

  # DELETE /networks/1
  def destroy
    respond_with @network.tap(&:destroy), location: index_path
  end

  private
    def index_path
      internal_networks_path
    end

    def find_network
      @network = Network.find(params[:id])
    end

    def network_params
      params.require(:network).permit(:name,:web)
    end
end
