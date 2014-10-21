Ember.Handlebars.helper 'capitalize', (str,options) ->
  str.capitalize() if str

Ember.Handlebars.helper "truncate", (str, len) ->
  if str? && str.length > len
    str.substring(0, len - 3) + "..."
  else
    str

Ember.Handlebars.helper "mail-to", (email) ->
  new Handlebars.SafeString "<a href='mailto:#{email}' title='Open your email app with #{email}' >#{email}</a>"


Ember.Handlebars.helper "markdown", (text) ->
  context = { name: 'Tonda' }

  if text?
    try
      text = Handlebars.compile(text)(context)
    catch error
      # TODO: inform about the parse error
      console.error error

    new Handlebars.SafeString(markdown.toHTML(text))
  else
    ''
