require 'action_view/helpers/asset_tag_helper'

module ApplicationHelper

  def icon( key, label = nil, hint_only = false)
    # label ||=  I18n.translate(key)
    # alt = label || key
    # tag = image_tag( "/images/icons/#{key}.png", :class => "icon", :alt => alt, :title => alt)
    # tag += "#{label}" if label and not hint_only
    # tag
    'ICO'
  end

  def gender_form_column(record, input_name)
    select(:record, :gender, [[ Volunteer.human_attribute_name('male'), 'm' ],
                              [ Volunteer.human_attribute_name('female'), 'f' ]])
  end

  def country_column(record)
    "#{flag(record.country)} #{record.country.name}" if record.country
  end

  def volant_number_to_currency(number)
     number_to_currency(number, :unit => Volant::Config::currency)
  end

  # Used by Active Scaffold when included to helper of some controller
  # TODO - replace by partial!
  def tags_column(record)
    image = icon('add_tag',t('txt.add_tag'), true)
    html = TaggableHelper::render_tags(record.tags)
#     html_id = "tags-popup-#{record.id}"
#     html << link_to_function( image, '', :id => html_id, :class => 'tag_action_button')
#     html << javascript_tag("$('#{html_id}').observe('click', show_tags_popup);")
    html
  end

  def flag(where)
    case where
       when String
      alt = where
      code = where
    when Country
      alt = where.name
      code = where.code.downcase
    end

    image_tag( "/images/flags/#{code}.png", :class => "icon", :alt => alt, :title => alt)
  end

  def gender_column(record)
    gender_icon(record)
  end

  def gender_in_list_column(record)
    gender_icon(record)
  end

  def email_link(email)
    link_to icon('email_go', email), "mailto:#{email}"
  end

  # TODO - presunout na vhodnejsi misto
  def volunteer_label(volunteer)
    gender_icon(volunteer) + volunteer.name
  end

  def bubble(id, content)
    render :partial => 'shared/bubble', :locals => { :id => id, :content => content }
  end

  def gender_icon(volunteer)
    icon_name = (volunteer.male?) ? 'male' : 'female'
    icon( icon_name, I18n.translate("model.#{icon_name}"), true)
  end

  def belongs_to_auto_completer_as( model, field)
    belongs_to_auto_completer :record, model, field, {},
    { :autocomplete => "off", :class => 'text-input'},
    { :method => 'GET' }
  end

  # Creates AS compatible column methods...(TODO description)
  def self.date_fields(*fields)
    fields.each do |field|
     eval %{
      def #{field}_column(record)
        (record.#{field}) ? I18n.localize(record.#{field}.to_date) : '-'
      end
     }
    end
  end

  def icon_button(action, script, html_options = {})
    script << '()' unless script[-1,:last] == ')'
    image = icon( action, t("txt.#{action}"), true)
    link_to_function( image, script);
  end

  # One option for select with localized labels.
  def option(selection)
    [ t("model.#{selection}"), selection.upcase ]
  end

    # Returns stylesheet link tag with the same basename as a current controller.
    # for: ApplicationController
    # returns: <link href="/stylesheets/application.css" media="screen" rel="stylesheet" type="text/css" />
    def stylesheet_links_for_controller
        controller_css = "#{@controller.controller_path}.css"
        path = "#{RAILS_ROOT}/public/stylesheets/#{controller_css}"
        stylesheet_link_tag(controller_css) if File.exists? path
    end



end
