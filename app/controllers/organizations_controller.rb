class OrganizationsController < ApplicationController

  def index
    render json: Organization.all, each_serializer: OrganizationSerializer
  end

  def show
    render json: Organization.find(params[:id])
  end
end
