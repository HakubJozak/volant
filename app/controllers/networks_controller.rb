class NetworksController < ApplicationController
  active_scaffold :networks do |config|
    highlight_required( config, Network)
    config.columns = [ :name ]
    config.list.columns = [ :name, :organizations ]
    config.list.sorting = { :name => 'ASC' }
  end
end
