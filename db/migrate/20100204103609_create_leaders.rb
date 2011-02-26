class CreateLeaders < ActiveRecord::Migration
  def self.up
    rename_table :volunteers, :people
    add_column :people, :type, :string, :default => 'Volunteer', :null => false
  end

  def self.down
    rename_table :people, :volunteers
    remove_columns :volunteers, :type
  end
end


