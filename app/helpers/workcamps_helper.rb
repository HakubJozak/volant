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

  def placement_popup_button(wc)
    data = {
      popover: true,
      content: render('placement_popup', workcamp: wc)
    }

    content_tag :button, data: data, class: 'btn btn-default btn-sm placement-info' do
      render 'free_places', workcamp: wc
    end
  end

end
