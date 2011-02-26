module WorkcampsHelper

  ApplicationHelper::date_fields :begin, :end

  def publish_mode_form_column(record, input_name)
    options = [ 'always', 'season', 'never' ].inject([]) do |all,option|
      all << [ Workcamp.human_attribute_name("publish_mode_#{option}"), option.upcase ]
    end

    select(:record, :publish_mode, options)
  end


  def name_column(record)
    truncate(record.name, :length => 30)
  end

  private


end
