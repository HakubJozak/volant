module CountryCounters
  extend ActiveSupport::Concern

  # include do
  #   after_save :update_country_free_counts
  #   after_destroy :update_country_free_counts
  # end

  def update_country_free_counts
    return unless country

    country.free_workcamps_count =
      country.workcamps.web_default.future.free.count
    
    country.free_ltvs_count = 
      country.ltv_projects.web_default.future.free.count

    country.save(validate: false)
  end  

end
