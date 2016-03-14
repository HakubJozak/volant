class AddFreeCountsToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :free_workcamps_count, :integer, default: 0
    add_column :countries, :free_ltvs_count, :integer, default: 0

    Country.reset_column_information
    
    Country.find_each { |c|
      Workcamp.find_by(country: c).try(:update_country_free_counts)
    }
  end
end
