class AddPartnerOrganization < ActiveRecord::Migration
  def change
    add_column :workcamps, :partner_organization, :string, limit: 4096
    add_column :workcamps, :project_summary, :string, limit: 4096    
  end
end
