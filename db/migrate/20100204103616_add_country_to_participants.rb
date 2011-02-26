class AddCountryToParticipants < ActiveRecord::Migration
  def self.up
    add_column :people, :country_id, :integer
  end

  def self.down
    remove_column :people, :country_id
  end
end
