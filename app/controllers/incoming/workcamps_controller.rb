require "#{RAILS_ROOT}/app/models/incoming/hosting"

module Incoming
  class WorkcampsController < ::WorkcampsController
    #    helper 'incoming/workcamps'

    active_scaffold 'Incoming::Workcamp' do |config|
      config.list.columns = [ 
                             :code, :name,
                             :free_places,
                             :free_places_for_males,
                             :free_places_for_females,
                             :participants,
                             :participants_count,
                             :bookings,
                             :bookings_count,
                             # :partners_contacts,
                             # :partners_emails,
                             # :partners_phones,
                             # :partners_address,
                             :leaderships,
                             :tags,
                             :quick_contact,
                             :infosheets
                            ]

      config.columns << [ :bookings_count, :participants_count ]
      config.columns[:bookings_count].label = ''
      config.columns[:participants_count].label = ''
      config.columns[:infosheets].label = ''


      [ :free_places, :free_places_for_females, :free_places_for_males ].each do |attr|
        config.columns[attr].set_link('nested', :parameters => { :associations => :participants })
      end

      config.nested.add_link help.icon('incoming_partners', Partner.human_name(:count => 2), true), [ :hostings ]

      config.action_links.add :email_all, :label => help.icon('email_go', I18n.t('texts.email_to_all'),true), 
                                          :type => :record, :method => :get, :inline => false

      config.action_links.add :participants_csv, :label => help.icon('export', I18n.t('txt.participants_to_csv'),true), 
                                          :type => :record, :method => :get, :inline => false

      config.action_links.add :friday_list_csv, :label => help.icon('export', I18n.t('txt.friday_list_to_csv'),false), 
                                          :type => :table, :method => :get, :inline => false


      ban_editing config, :leaderships, :participants, :bookings_count, :participants_count
    end

    # FIXME - remove and use filter in views
    # def conditions_for_collection
    #   [ '(workcamps.begin >= ?)', Date.new(2010,1,1) ]
    # end
    
    def email_all
      wc = Incoming::Workcamp.find(params[:id])
      addresses = wc.participants.map { |p| p.organization.email.to_s.strip }
      redirect_to "mailto:#{addresses.join(',')}"
    end

    def participants_csv
      wc = Incoming::Workcamp.find(params[:id])
      render_csv( wc.participants_to_csv, :name => "#{wc.code}-#{wc.name}-participants")
    end

    def friday_list_csv      
      render_csv( Incoming::Workcamp.friday_list, :name => "Friday list on #{Date.today.to_s}")
    end

    def do_new
      limit = 10
      org = Organization.default_organization

      @record = Workcamp.new( :country => org.country,
      :organization => org,
      :minimal_age => 18,
      :maximal_age => 99,
      :language => 'English',
      :places => limit,
      :places_for_males => limit / 2,
      :places_for_females => limit / 2,
      :capacity_males => limit,
      :capacity_females => limit / 2,
      :capacity => limit / 2)
    end
    
  end
end
