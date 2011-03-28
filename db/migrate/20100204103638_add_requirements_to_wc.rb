class AddRequirementsToWc < ActiveRecord::Migration
  def self.up
    add_column :workcamps, :requirements, :text
  end

  def self.down
    add_column :workcamps, :requirements
  end
end
