class Incoming::BookingsController < ApplicationController
  
  active_scaffold 'Incoming::Booking' do |c|
    c.columns = [ :country, :organization, :workcamp, :gender ]
    c.columns[:country].form_ui = :select
    c.columns[:organization].form_ui = :select
  end

end
