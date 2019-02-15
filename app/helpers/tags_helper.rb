module TagsHelper
  def tag_list(record)
    record.tags.map { |t| tag_span(t) }.join(' ').html_safe
  end

  def tag_span(tag)
    style = "color:#{tag.text_color}; background-color:#{tag.color};"

    content_tag :span, class: 'label label-default', style: style do
      if tag.symbol
        [ fa(tag.symbol), h(tag.name) ].join(' ').html_safe
      else
        h(tag.name)
      end
    end
  end

  
end
