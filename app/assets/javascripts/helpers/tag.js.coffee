Ember.Handlebars.helper 'tag', (tag) ->
  name = tag.get('name')
  color = tag.get('color')
  text_color = tag.get('text_color')
  new Handlebars.SafeString "<span class='label label-default' style='color:#{text_color}; background-color:#{color};' >#{name}</span>"

Ember.Handlebars.helper 'example-tag', (color,text_color) ->
  new Handlebars.SafeString "<span class='label label-default' style='color:#{text_color}; background-color:#{color};' >Example</span>"

Ember.Handlebars.helper 'tag-list', (tags) ->
  return unless tags
  html = tags.map (tag) ->
    name = tag.get('name')
    color = tag.get('color')
    text_color = tag.get('text_color')
    "<span class='label label-default' style='color:#{text_color}; background-color:#{color};' >#{name}</span>"
  new Handlebars.SafeString html.join(' ')
