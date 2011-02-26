class AddOrgToParticipant < ActiveRecord::Migration
  def self.up
    add_column :people, :organization_id, :integer
  end

  def self.down
    remove_columns :people, :organization_id
  end
end
