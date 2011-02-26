class EmailContactsController < ApplicationController
  helper :email_contacts

  active_scaffold :email_contacts do |config|
    config.columns = [ :name, :address, :kind, :notes ]
  end
end
