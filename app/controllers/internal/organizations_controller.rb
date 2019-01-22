class Internal::OrganizationsController < Internal::BaseController

  include MinimalResponders

  before_action :find_organization, except: [ :index, :create, :new ]

  def index
    @orgs = organizations.includes(:country, :country => [:country_zone]).includes(:emails,:networks)

    if filter[:query].present?
      @query = filter[:query]
      @orgs = @orgs.query(@query) 
    end

    @orgs = @orgs.order('countries.name_en ASC, organizations.name ASC').page(current_page).per(per_page)
  end  

  def new
    @org = Organization.new
  end

  def create
    @org = Organization.new(org_params)
    @org.save
    respond_with @org, location: index_path
  end

  def destroy
    respond_with @org.tap(&:destroy), location: index_path
  end

  def update
    @org.update(org_params)
    respond_with @org, location: index_path
  end

  private
    def index_path
      internal_organizations_path
    end

    def organizations
      Organization
    end

    def find_organization
      @org = organizations.find(params[:id])
    end

    def filter
      params.permit(:query,:p)
    end

    def org_params
      params.require(:organization).permit(:name, :code, :description, :country_id, :website, :phone, :mobile,:contact_person,:network_ids => [])
    end
end
