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


  def duration_info(wc)
    if wc.variable_dates
      if wc.duration
        [ fa('calendar-times-o'),
          wc.duration,
          "&nbsp;days" ].join.html_safe
      end
    else
       "#{ wc.duration_info }&nbsp;days"
    end
  end

end
