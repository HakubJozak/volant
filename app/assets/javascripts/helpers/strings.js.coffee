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

Ember.Handlebars.helper "join", (array, attribute) ->
  names = array.map (r) -> r.get(attribute)
  names.join(', ')

Ember.Handlebars.helper "join-emails", (array, attribute) ->
  addresses = array.map (r) -> r.get(attribute)
  htmls = addresses.map (email) ->
    "<a href='mailto:#{email}' target='_blank' title='Open your email app with #{email}' >#{email}</a>"
  new Handlebars.SafeString htmls.join(', ')


Ember.Handlebars.helper "mail-to", (email) ->
  new Handlebars.SafeString "<a href='mailto:#{email}' title='Open your email app with #{email}' >#{email}</a>"

Ember.Handlebars.helper "external-link", (link) ->
  a = "<a href='#{link}' target='_blank'><i class='fa fa-external-link'></i></a>"
  new Handlebars.SafeString a

Ember.Handlebars.helper "log-message", (level,msg) ->
  new Handlebars.SafeString "<p class='text-#{level}'>#{msg}</p>"


Ember.Handlebars.helper "badge-count", (number) ->
  if number and number != 0
    new Handlebars.SafeString("<span class=\"badge\">#{number}</span>")
  else
    ''
