class AddImportedAttribute < ActiveRecord::Migration
  def self.up
    add_column :workcamps, :state, :string
  end

  def self.down
    remove_column :workcamps, :state
  end
end
