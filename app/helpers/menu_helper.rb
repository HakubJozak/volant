module MenuHelper

  def self.recent_years
    this_year = Date.today.year
    [ this_year +1, this_year, this_year - 1 ]
  end

  # TODO: remove html_safe flood
  def submenu( title = nil, params = {}, &block)
    html_id = submenu_default(:html_id, "#{title.to_s}-menu", params).html_safe
    default_label = image_tag('/images/icons/folder.png') + t('txt.menu.' + title.to_s, params)
    label = submenu_default(:label, default_label, params)

    inside = ''

    if params[:cache]
      cache(html_id) { inside << with_output_buffer(&block) }
    else
      inside << with_output_buffer(&block)
    end

    @hcart.register(html_id)
    style = @hcart.hidden?(html_id) ? 'display:none' : ''

    c =  "<li>"
    c << "<strong onclick=\"show_or_hide_menu('#{html_id}')\">"
    c << label
    c << "</strong>"
    c << "<ul id=\"#{html_id}\" style=\"#{style}\">"


    (c + inside + '</ul></li>').html_safe
  end


  def apply_form_menu_item(year, filter)
    options = {}
    state = filter[:state]
    tag = filter[:tag]

    if state
      options[:state_filter] = state
      label = icon(state, t("txt.menu.by_state.#{state.to_s}"))
    elsif tag
      options[:tag_id] = tag.id
      label = tag_box(tag) + tag.name
    end

    options[:year] = year
    menu_item label, outgoing_apply_forms_path(options)
  end

  def workcamp_menu_item(year, tag = nil, organization = nil)
    options = {}
    options[:year] = year

    if tag
      options[:tag_id] = tag.id
      label = tag_box(tag) + tag.name
    elsif organization
      options[:organization_id] = organization.id
      label = flag(organization.country) + organization.country.name + '-'+ organization.name
    else
      label = icon(:workcamps, t('txt.menu.all'))
    end

    menu_item label, outgoing_workcamps_path(options)
  end

  def tag_box(tag)
    style = "background-color: #{tag.color}; "
    "<div class=\"tagbox\" style=\"#{style}\">&nbsp;</div>"
  end

  def model_menu_item(clazz, prefix = '')
    label = clazz.model_name.human(:count => 2)
    name = clazz.to_s.tableize.gsub(/\//, '_')
    menu_item(icon(name,label), send("#{prefix}#{name}_path"))
  end

  def menu_item(icon, options)
    "<li>#{link_to icon, options}</li>".html_safe
  end

  private

  def submenu_default(key, default, params)
    if params[key]
      result = params[key]
      params.delete(key)
    else
      result = default
    end

    result
  end

end
