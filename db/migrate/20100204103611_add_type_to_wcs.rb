class AddTypeToWcs < ActiveRecord::Migration
  def self.up
    add_column :workcamps, :type, :string, :null => false, :default => 'Outgoing::Workcamp'
    Workcamp.reset_column_information

    organization = Organization.find_by_code('SDA')
    Workcamp.find(:all, :conditions => { :organization_id => organization.id }).each do |wc|
      wc.type = 'Incoming::Workcamp'
      wc.save!
    end if organization
  end

  def self.down
    remove_columns :workcamps, :type
  end
end
