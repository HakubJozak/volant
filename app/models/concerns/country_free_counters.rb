module CountryFreeCounters

  # include do
  #   after_save :update_country_free_counts
  #   after_destroy :update_country_free_counts
  # end

  module Country
    extend ActiveSupport::Concern
    def update_free_counts
      self.free_workcamps_count =
        workcamps.web_default.future.free.count

      self.free_ltvs_count =
        ltv_projects.web_default.future.free.count

      save(validate: false)      
    end
  end
  
  module Account
    extend ActiveSupport::Concern    

    included do
      after_save :update_countries_free_counts      
    end

    def update_countries_free_counts
      if season_end_changed?
        ::Country.find_each do |country|
          country.update_free_counts
        end
      end
    end
  end

  
  module Workcamp
    # extend ActiveSupport::Concern
    
    def update_country_free_counts
      country.try(:update_free_counts)
    end
  end
end
