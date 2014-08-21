Ember.Handlebars.helper 'tag', (tag) ->
  name = tag.get('name')
  color = tag.get('color')
  text_color = tag.get('text_color')
  new Handlebars.SafeString "<span class='label label-default' style='color:#{text_color}; background-color:#{color};' >#{name}</span>"
