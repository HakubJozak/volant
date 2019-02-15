module MenuHelper

  def default_mode_select
    data = ProjectScope::MODES.map do |mode|
      # i.e. internal_incoming_workcamps_path
      url_method = "internal_#{mode}_workcamps_path"
      [ mode.capitalize, 'data-url': public_send(url_method) ]
    end

    opts = options_for_select(data, selected: project_scope.mode)
    select_tag 'default_mode', opts, class: 'form-control'
  end

  def default_year_select
    data = ProjectScope::YEARS.map do |year|
      [ year, 'data-url': root_path ]
    end

    data.unshift [ 'All', nil]

    opts = options_for_select(data, selected: project_scope.year.to_i)
    select_tag 'default_year', opts, class: 'form-control'
  end

end
