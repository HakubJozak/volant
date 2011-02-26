class AddTypeToWcs < ActiveRecord::Migration
  def self.up
    add_column :workcamps, :type, :string, :null => false, :default => 'Outgoing::Workcamp'
    Workcamp.reset_column_information

    Workcamp.find(:all, :conditions => { :organization_id => Organization.find_by_code('SDA').id }).each do |wc|
      wc.type = 'Incoming::Workcamp'
      wc.save!
    end
  end

  def self.down
    remove_columns :workcamps, :type
  end
end
