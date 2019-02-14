module ApplicationHelper
  def gender_sign(record)
    if record.gender == 'f'
      fa('venus')
    else
      fa('mars')
    end
  end

  def tag_list(record)
    record.tags.map do |tag|
      tag_span(tag)
    end.join(' ').html_safe
  end

  def tag_span(tag)
    style = "color:#{tag.text_color}; background-color:#{tag.color};"
    content_tag :span, class: 'label label-default', style: style do
      if tag.symbol
        fa(tag.symbol) + " " + h(tag.name)
      else
        h(tag.name)
      end
    end
  end

  def form_state_icon(state)
    key = state.name
    icon = case key
             when :not_paid then 'upload'
             when :paid then 'money'
             when :accepted then 'thumbs-up'
             when :rejected then 'thumbs-down'
             when :asked then 'envelope'
             when :infosheeted then 'file'
             when :confirmed then 'suitcase'
             when :cancelled then 'times'
             else ''
          end

    content_tag :span, class: "fa-stack state-icon #{key}", title: "#{state.info}" do
      content_tag(:i, nil, class: "fa fa-stack-2x fa-circle #{key}") +
      content_tag(:i, nil, class: "fa fa-stack-1x fa-inverse fa-#{icon} #{key}")
    end

  end
end
