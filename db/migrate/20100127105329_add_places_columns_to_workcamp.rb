class AddPlacesColumnsToWorkcamp < ActiveRecord::Migration
  def self.up
    add_column :workcamps, :accepted_places, :integer, :default => 0, :null => false
    add_column :workcamps, :accepted_places_males, :integer, :default => 0, :null => false
    add_column :workcamps, :accepted_places_females, :integer, :default => 0, :null => false
    add_column :workcamps, :asked_for_places, :integer, :default => 0, :null => false
    add_column :workcamps, :asked_for_places_males, :integer, :default => 0, :null => false
    add_column :workcamps, :asked_for_places_females, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :workcamps, :accepted_places
    remove_column :workcamps, :accepted_places_males
    remove_column :workcamps, :accepted_places_females
    remove_column :workcamps, :asked_for_places
    remove_column :workcamps, :asked_for_places_males
    remove_column :workcamps, :asked_for_places_females
  end
end
