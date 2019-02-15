module WorkcampsHelper

  def age_range(wc)
    min = wc.minimal_age
    max = wc.maximal_age

    if min.present? and max.present?
      "#{min} - #{max}"
    elsif min.present?
      "#{min} <"
    elsif max.present?
      "< #{max}"
    else
      ''
    end
  end


  def workcamp_dates(wc)
    if workcamp.variable_dates
      if workcamp.duration
        [ fa('calendar-times-o'),
          workcamp.duration,
          "&nbsp;days" ].join.html_safe
      end
    else
       "#{ workcamp.duration_info }&nbsp;days"
    end
  end

end
