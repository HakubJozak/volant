class AddRegionAndZoneToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :region, :string, null: false, default: '1'
    add_column :countries, :zone, :string
  end
end
