class RenameCzColumnsToCs < ActiveRecord::Migration
  def self.up
    rename_column :countries, :name_cz, :name_cs
    rename_column :languages, :name_cz, :name_cs
    rename_column :workcamp_intentions, :description_cz, :description_cs
  end

  def self.down
    rename_column :countries, :name_cs, :name_cz
    rename_column :languages, :name_cs, :name_cz
    rename_column :workcamp_intentions, :description_cs, :description_cz
  end
end
