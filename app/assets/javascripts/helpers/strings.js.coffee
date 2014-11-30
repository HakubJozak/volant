Ember.Handlebars.helper 'capitalize', (str,options) ->
  str.capitalize() if str

Ember.Handlebars.helper 'humanize', (str,options) ->
  if str
    str.capitalize().replace('_',' ')


Ember.Handlebars.helper "truncate", (str, len) ->
  if str? && str.length > len
    str.substring(0, len - 3) + "..."
  else
    str

Ember.Handlebars.helper "mail-to", (email) ->
  new Handlebars.SafeString "<a href='mailto:#{email}' title='Open your email app with #{email}' >#{email}</a>"


Ember.Handlebars.helper "badge-count", (number) ->
  if number and number != 0
    new Handlebars.SafeString("<span class=\"badge\">#{number}</span>")
  else
    ''
