class AddContinentToZountryZone < ActiveRecord::Migration
  def change
    add_column :country_zones, :continent, :string
  end
end
