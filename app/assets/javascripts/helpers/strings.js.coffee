Ember.Handlebars.helper 'capitalize', (str,options) ->
  str.capitalize() if str

Ember.Handlebars.helper "join-errors", (errors) ->
  errors.reduce ((previous, item, index) ->
    if index == 0
      "#{item.attribute} #{item.message}"
    else
      "#{previous}, #{item.attribute} #{item.message}"
  )


Ember.Handlebars.helper "truncate", (str, len) ->
  if str? && str.length > len
    str.substring(0, len - 3) + "..."
  else
    str
