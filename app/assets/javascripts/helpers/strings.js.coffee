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

Ember.Handlebars.helper "mail-to", (email) ->
  new Handlebars.SafeString "<a href='mailto:#{email}' title='Open your email app with #{email}' >#{email}</a>"


Ember.Handlebars.helper "markdown", (text) ->
  if text?
    new Handlebars.SafeString(markdown.toHTML(text))
  else
    ''
