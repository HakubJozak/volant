module ApplicationHelper

  def fa(name)
    "<i class='fa fa-#{name}'></i>".html_safe
  end

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

  def small_flag(country)
    code = country.code.upcase
    name = country.name
    url = "flags-iso/flat/24/#{code}.png"
    image_tag url, class: 'flag small-flag', alt: name, title: name
  end

  def flag(country)
    code = country.code.upcase
    name = country.name
    url = "flags-iso/flat/32/#{code}.png"
    image_tag url, class: 'flag small-flag', alt: name, title: name
  end

end

   

