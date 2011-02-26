require 'db/migrate/20090214125124_create_advanced_workcamp_view.rb'

class AdditionalWcFields < ActiveRecord::Migration
  def self.up
    CreateAdvancedWorkcampView.down
    add_column :workcamps, :capacity_natives, :integer
    add_column :workcamps, :capacity_teenagers, :integer
    add_column :workcamps, :capacity_males, :integer
    add_column :workcamps, :capacity_females, :integer
    add_column :workcamps, :airport, :string
    add_column :workcamps, :train, :string
    CreateAdvancedWorkcampView.up
  end

  def self.down
    CreateAdvancedWorkcampView.down
    remove_column :workcamps, :capacity_natives
    remove_column :workcamps, :capacity_teenagers
    remove_column :workcamps, :capacity_males
    remove_column :workcamps, :capacity_females
    remove_column :workcamps, :airport
    remove_column :workcamps, :train
    CreateAdvancedWorkcampView.up
  end
end
