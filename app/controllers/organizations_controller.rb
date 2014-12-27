class OrganizationsController < ApplicationController
  respond_to :json
  before_action :find_organization, except: [ :index, :create ]

  def index
    if filter[:p].present?
      orgs = organizations.joins(:country).includes(:networks)
      orgs = orgs.query(filter[:q]) if filter[:q].present?
      orgs = orgs.order('countries.code ASC, organizations.name ASC').page(current_page)
      render json: orgs, meta: { pagination: pagination_info(orgs) }, each_serializer: OrganizationSerializer
    else
      orgs = organizations.all
      render json: orgs, each_serializer: MiniOrganizationSerializer
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
    params.require(:organization).permit(:name, :code, :country_id, :website, :phone, :mobile)
  end

end
