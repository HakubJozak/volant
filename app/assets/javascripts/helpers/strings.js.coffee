Ember.Handlebars.helper 'capitalize', (str,options) ->
  str.capitalize() if str

Ember.Handlebars.helper "truncate", (str, len) ->
  if str? && str.length > len
    str.substring(0, len - 3) + "..."
  else
    str
