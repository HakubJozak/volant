require 'db/migrate/20090214125124_create_advanced_workcamp_view.rb'

class AddPublishedColumn < ActiveRecord::Migration
  def self.up
    CreateAdvancedWorkcampView.down
    # TODO - user real enum - ALWAYS, SEASON, NEVER are the options
    add_column :workcamps, :publish_mode, :string, :null => false, :default => 'ALWAYS'
    CreateAdvancedWorkcampView.up
  end

  def self.down
    CreateAdvancedWorkcampView.down
    remove_column :workcamps, :publish_mode
    CreateAdvancedWorkcampView.up
  end
end
