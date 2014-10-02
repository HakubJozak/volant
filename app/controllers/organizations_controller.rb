class OrganizationsController < ApplicationController
  respond_to :json
  before_action :find, only: [ :update, :destroy, :show ]

  def index
    render json: Organization.all, each_serializer: OrganizationSerializer
  end

  def show
    render json: Organization.find(params[:id])
  end

  def update
    if  @org.update(org_params)
      render json: @org, serializer: OrganizationSerializer
    else
      render json: { errors: @org.errors }, status: 422
    end
  end


  private

  def find
    @org = Organization.find(params[:id])
  end

  def org_params
    params.require(:organization).permit(:name, :code, :country_id, :website, :phone, :mobile)
  end

end
