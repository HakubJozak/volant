makeTagMarkup = (tag) ->
  color = tag.get('color')
  text_color = tag.get('textColor')
  name = tag.get('name') || ''
  symbol = tag.get('symbol')

  text = if symbol
           "<i class='fa fa-#{symbol}'></i> #{name}"
         else
           name

  "<span class='label label-default' style='color:#{text_color}; background-color:#{color};' >#{text}</span>"


Ember.Handlebars.helper 'tag', (tag) ->
  new Handlebars.SafeString makeTagMarkup(tag)

Ember.Handlebars.helper 'tag-list', (tags) ->
  if tags
    html = tags.map(makeTagMarkup)
    new Handlebars.SafeString html.join(' ')
