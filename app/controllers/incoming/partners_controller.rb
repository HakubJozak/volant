class Incoming::PartnersController < ApplicationController

  active_scaffold 'Incoming::Partner' do |c|
    c.columns = [ :name, :contact_person, :phone, :email, :website, 
                  :address, :negotiations_notes, :notes ]

    c.list.columns = [ :name, :contact_person, :phone, :email, :website, :address ]

    highlight_required(c, Incoming::Partner)
  end
end
