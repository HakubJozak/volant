class Incoming::LeadershipsController < ApplicationController
  active_scaffold 'Incoming::Leadership' do |config|
    config.columns = [ :leader, :workcamp ]
    # config.columns[:leader].association.reverse = 'Incoming::Leadership'
    # config.columns[:workcamp].association.reverse = 'Incoming::Leadership'
    config.columns[:leader].form_ui = :select
  end
end
