class PartnershipsController < ApplicationController
  active_scaffold :partnerships do |config|
    highlight_required( config, Partnership)
  end
end
