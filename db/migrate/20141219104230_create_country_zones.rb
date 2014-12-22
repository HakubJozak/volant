class CreateCountryZones < ActiveRecord::Migration
  def change
    create_table :country_zones do |t|
      t.string :name_en
      t.string :name_cz
      t.timestamps
    end

    add_column :countries, :region, :string, null: false, default: '1'
    add_column :countries, :country_zone_id, :integer

    Adhoc::create_country_zones
  end
end
