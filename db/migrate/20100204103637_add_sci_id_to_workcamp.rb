class AddSciIdToWorkcamp < ActiveRecord::Migration
  def self.up
    add_column :workcamps, :sci_id, :integer, :references => nil
  end

  def self.down
    remove_column :workcamps, :sci_id
  end
end
