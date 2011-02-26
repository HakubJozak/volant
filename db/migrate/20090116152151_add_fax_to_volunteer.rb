class AddFaxToVolunteer < ActiveRecord::Migration
  def self.up
    add_column :volunteers, :fax, :string
  end

  def self.down
    remove_column :volunteers, :fax
  end
end
