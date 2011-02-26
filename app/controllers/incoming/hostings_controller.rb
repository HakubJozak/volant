class Incoming::HostingsController < ApplicationController
  active_scaffold 'Incoming::Hosting' do |c|
    c.columns = [ :partner, :workcamp ]
    c.columns[:partner].form_ui = :select
  end
end
