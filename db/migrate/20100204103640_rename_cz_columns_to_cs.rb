class RenameCzColumnsToCs < ActiveRecord::Migration
  def self.up
    rename_column :countries, :name_cz, :name_cs
    rename_column :languages, :name_cz, :name_cs
    rename_column :workcamp_intentions, :description_cz, :description_cs
    User.find_all_by_locale('cz').each {|u| u.update_attribute(:locale, 'cs')}
  end

  def self.down
    rename_column :countries, :name_cs, :name_cz
    rename_column :languages, :name_cs, :name_cz
    rename_column :workcamp_intentions, :description_cs, :description_cz
    User.find_all_by_locale('cs').each {|u| u.update_attribute(:locale, 'cz')}
  end
end
