class CountriesController < ApplicationController
  active_scaffold :countries do |config|
    config.columns = [ :code, :triple_code, :name_cz, :name_en ]    
    config.list.columns = [ :flag, :code, :triple_code, :name_cz, :name_en ]    
    config.actions.exclude :delete
  end
end
