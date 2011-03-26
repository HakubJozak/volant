class ::WorkcampsController < ::FilteringController
  helper :workcamps
  before_filter :reset_filter, :year_term_filter, :tag_filter, :organization_filter, :adjust_title
  before_filter :tolerate_slashed_date, :only => [ :create, :update ]

  active_scaffold :workcamp do |config|
    config.columns = [ :country, :organization,
                       :code, :name,
                       :begin, :end,
                       :language,
                       :publish_mode,
                       :intentions,
                       :taggings,
                       # not visible in edits
                       :free_places,
                       :free_places_for_males,
                       :free_places_for_females,
                       :infosheets
                     ]

    group config, 'age', :minimal_age, :maximal_age
    group config, 'capacity_group', :capacity, :capacity_males, :capacity_females, :capacity_natives, :capacity_teenagers
    group config, 'place_limits', :places, :places_for_males, :places_for_females
    group config, 'fees', :extra_fee, :extra_fee_currency
    group config, 'wcinfo_group', :airport, :train, :region,
                                  :latitude, :longitude,
                                  :workdesc, :area, :accomodation, :description, :notes

    config.columns[:tags].clear_link
    config.columns[:organization].form_ui = :select
    config.columns[:organization].options = { :include_blank => nil }
    config.columns[:organization].search_sql = 'organization.name'
    config.columns[:publish_mode].description = Workcamp.human_attribute_name('publish_mode_desc')
    config.columns[:intentions].collapsed = false
    config.columns[:intentions].form_ui = :select
    config.columns[:taggings].collapsed = false
    config.columns[:infosheets].collapsed = true
    config.columns[:description].form_ui = :text_editor

    config.list.sorting = { :code => 'ASC' }
    config.list.columns = [ :country, :organization, :code, :name,
                            :begin, :end,
                            :free_places,
                            :free_places_for_males,
                            :free_places_for_females
                          ]

    # config.action_links.add :export_alliance_xml,
    #   :controller => 'workcamps',
    #   :label => help.icon('export', Workcamp.human_attribute_name('alliance_export')),
    #   :popup => false,
    #   :type => :table,
    #   :method => :get,
    #   :inline => false

    ban_editing config, :term,
                        :infosheets,
                        :free_places,
                        :free_places_for_males,
                        :free_places_for_females

    setup_country_field(config)
    setup_places_fields(config, 'free_')
  end



  def export_alliance_xml
    # using active scaffold filters
    finder_options = { :conditions => all_conditions, :joins => joins_for_finder }
      #,:include => [ :country, :organization ]}
    wcs = Workcamp.find(:all, finder_options)
    render :xml => AllianceExporter.export(wcs)
  end

  protected

  def do_new
    @record = Workcamp.new :country => Country.find_by_code('CZ'),
                           :minimal_age => 18,
                           :maximal_age => 99,
                           :language => 'English',
                           :places => 2,
                           :places_for_males => 2,
                           :places_for_females => 2
  end

  # TODO - is there some much better way?
  # Allows begin/end date in format 25/01/2003
  def tolerate_slashed_date
    [ 'begin', 'end' ].each do |attr|
      value = params['record'][attr]
      params['record'][attr] = value.gsub(/\//, '.') if value
    end
  end

  # def after_create_save(record)
  #   # needed to reflect the SQL view columns
  #   record.reload
  # end

  def year_term_filter
    year_filter('"begin"')
  end

  def organization_filter
    if id = params[:organization_id]
      @filter_params << id
      @filter_sql << " AND (#{Workcamp.table_name}.organization_id = ?) "
      @title_suffixes << Organization.find(id).name
    end
  end

  def conditions_for_collection
    [ '(state IS NULL) AND ' + @filter_sql ].concat(@filter_params)
  end


end
