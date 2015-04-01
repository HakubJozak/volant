class AddSendingOrganization < ActiveRecord::Migration
  def change
    add_column :apply_forms, :organization_id, :integer
    add_column :apply_forms, :country_id, :integer
  end
end
