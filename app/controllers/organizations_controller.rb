class OrganizationsController < ApplicationController
  respond_to :json
  before_action :find_organization, except: [ :index, :create ]

  def index
    orgs = organizations.includes(:country, :country => [:country_zone]).includes(:emails,:networks)

    if filter[:p].present?
      orgs = orgs.query(filter[:q]) if filter[:q].present?
      orgs = orgs.order('countries.name_en ASC, organizations.name ASC').page(current_page).per(per_page)
      render json: orgs, meta: { pagination: pagination_info(orgs) }, each_serializer: OrganizationSerializer
    else
      render json: orgs.all, each_serializer: OrganizationSerializer
    end
  end

  def show
    render json: @org
  end

  def create
    @org = Organization.new(org_params)
    if @org.save
      render json: @org, serializer: OrganizationSerializer
    else
      render_error(@org)
    end
  end

  def destroy
    @org.destroy
    head :no_content
  end

  def update
    if  @org.update(org_params)
      render json: @org, serializer: OrganizationSerializer
    else
      render_error(@org)
    end
  end

  private

  def organizations
    Organization
  end

  def find_organization
    @org = organizations.find(params[:id])
  end

  def filter
    params.permit(:q,:p)
  end

  def org_params
    params.require(:organization).permit(:name, :code, :description, :country_id, :website, :phone, :mobile,:contact_person,:network_ids => [])
  end

end
