class ApplicationController < VisibilityController
  protect_from_forgery
  layout 'admin'
  helper :menu

  include AuthenticatedSystem

  before_filter :login_required, :set_locale, :active_scaffold_per_request_config
  filter_parameter_logging :password, :password_confirmation

  ActiveScaffold.set_defaults do |config|
    #  config.list.empty_field_text = I18n.add('add')
    config.show.link.label = Helper.instance.icon('show', I18n.t('show'), true)
    config.update.link.label = Helper.instance.icon('update', I18n.t('update'), true) if config.actions.include?(:update)
    config.delete.link.label = Helper.instance.icon('delete', I18n.t('delete'), true) if config.actions.include?(:delete)
  end


  def render_csv( data, options)
    today = Date.today
    date = "#{today.day}-#{today.month}-#{today.year}"
    name = options[:name] || 'data'

    # TODO put into constants?
    response.headers['Content-Type'] = 'text/csv; charset=utf-8; header=present'
    response.headers['Content-Disposition'] = "attachment; filename=#{name}-#{date}.csv"
    render :text => data
  end


  def adjust_title
    if c = active_scaffold_config
      label  = c.model.human_name(:count => 2) 
      label += ' (' + @title_suffixes.join(',') + ')' if @title_suffixes and !@title_suffixes.empty?
      c.list.label = label
    end
  end

  def set_locale
    if current_user
      I18n.locale = current_user.locale
    end
  end

  def self.active_scaffold_controller_for(clazz)
    return Outgoing::ApplyFormsController if clazz == ApplyForm
    super(clazz)
  end

  def visible
  end

  # TODO - use 'helpers' method from Rails instead?
  def self.help
    Helper.instance
  end

  protected

  def nested?
    (params["associations"].nil? and params['parent_column'].nil? and params['parent_model'].nil?)
  end

  public

  def active_scaffold_per_request_config
    # ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default] = '%d.%m.%Y'
    # ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:default] = '%d.%m.%Y %H:%M'

    if I18n.locale == 'cz'
      CalendarDateSelect.format = :finnish
    else
      CalendarDateSelect.format = :iso_date
    end

    if config = active_scaffold_config
      config.list.always_show_search = !nested?
    end
  end

  # TODO - move elsewhere
  def auto_complete_belongs_to_for_record_apply_form_name
    @apply_forms = ApplyForm.find_records_like(params[:apply_form][:name])
    render :inline => '<%= model_auto_completer_result(@apply_forms, :name) %>'
  end

  # TODO - move elsewhere
  def auto_complete_belongs_to_for_record_volunteer_name
    @volunteers = Volunteer.find_by_name_like(params[:volunteer][:name])
    render :inline => '<%= model_auto_completer_result(@volunteers, :name) %>'
  end

  # TODO - move elsewhere
  def auto_complete_belongs_to_for_record_workcamp_name
    @workcamps = Outgoing::Workcamp.find_by_name_or_code(params[:workcamp][:name])
    render :inline => '<%= model_auto_completer_result(@workcamps, :to_label) %>'
  end

  protected

  # TODO - Fixes problem with "view" row creation - is there some better way?
  def sql_view_hack
    ApplyForm.reset_column_information
  end

  # TODO - include this method directly to ActiveScaffold::Config::Core
  def self.ban_editing( config, *fields)
    fields.each do |field|
      config.update.columns.exclude field
      config.create.columns.exclude field
    end
  end

  # TODO - include this method directly to ActiveScaffold::Config::Core
  # TODO - get model from config variable
  def self.highlight_required(config, model)
    model.not_null_columns.each do |column|
      name = (column.name[-3,:last] != '_id') ? column.name.dup : column.name[0..-4]
      name << "_string" if [:date, :datetime].include? column.type
      definition = config.columns[name.to_sym]
      definition.required = true if definition
    end
  end

  def self.group(config, name, *attrs)
    options = attrs.extract_options!

    [ config.update, config.create ].each do |c|
      c.columns.add_subgroup name do |group|
        group.add *attrs
        group.collapsed = (options[:collapsed] == true)
      end
    end
  end

  def self.setup_places_fields(config, prefix = '')
    config.columns[:"#{prefix}places"].label = help.icon('places', Workcamp.human_attribute_name(:free_places), true)
    config.columns[:"#{prefix}places_for_males"].label = help.icon('male', Workcamp.human_attribute_name(:free_places_for_males), true)
    config.columns[:"#{prefix}places_for_females"].label = help.icon('female', Workcamp.human_attribute_name(:free_places_for_females), true)
    
    config.columns[:"#{prefix}places"].sort_by :sql => "#{Workcamp.table_name}.places - #{Workcamp.table_name}.accepted_places"
    config.columns[:"#{prefix}places_for_males"].sort_by :sql => "#{Workcamp.table_name}.places - #{Workcamp.table_name}.accepted_places_males"
    config.columns[:"#{prefix}places_for_females"].sort_by :sql => "#{Workcamp.table_name}.places - #{Workcamp.table_name}.accepted_places_females"
  end

  def self.setup_country_field(config)
    config.columns[:country].form_ui = :select
    config.columns[:country].options = { :include_blank => nil }
    config.columns[:country].search_sql = "countries.name_#{I18n.locale}"
    config.columns[:country].sort_by :sql => "countries.name_#{I18n.locale}"
    config.search.columns << :country if config.search
  end

  # Adds table level (unless overriden by options) link
  # to ActiveScaffold local configuration using either
  # 'action' or :action and :controller options entries
  # to create HREF. The parameter definition is updated
  # for any specific changes from the options hash.
  def self.action_link(config, action, label, icon, options = nil)
      params = {:crud_type => nil,
                :label => label, #render_to_string('<%= icon( icon, label) %>'),
                :type => :table,
                :inline => false }

      params.update(options) if options
      config.action_links.add( action, params)
  end

  # class << self
  #   alias :old_inherited :inherited
  # end

  # def self.inherited(subclass)
  #   logger.info("!!!!!!!! #{subclass}")
  #   old_inherited(subclass)
  # end

end
