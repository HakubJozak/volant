class OrganizationsController < ApplicationController

  def index
    orgs = Organization.all
    render json: orgs, each_serializer: OrganizationSerializer
  end

  def show
    render json: Organization.find(params[:id])
  end
end
