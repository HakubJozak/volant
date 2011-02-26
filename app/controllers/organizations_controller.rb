class OrganizationsController < ApplicationController
  helper :email_contacts
  cache_sweeper :menu_sweeper

  active_scaffold :organizations do |config|
    config.list.always_show_search = true
    config.list.sorting = { :name => 'ASC' }

    config.columns[:country].form_ui = :select
    config.columns = [ :country, :name, :code, :contact_person,
                       :phone, :mobile, :fax, :website,
                       :emails, :partnerships ]
    config.list.columns = [ :country, :name_with_link, :email, :workcamps, :partnerships ]

    config.columns[:partnerships].collapsed = true
    config.columns[:partnerships].clear_link
    setup_country_field(config)

    highlight_required( config, Organization)
  end

end
