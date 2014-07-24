Ember.Handlebars.helper 'image_path', (path) ->
  window.image_path(path)

Ember.Handlebars.helper 'flag', (country) ->
  code = country.get('code').toUpperCase()
  name = country.get('name')
  url = window.image_path("flags-iso/flat/32/#{code}.png")
  new Handlebars.SafeString "<img src='#{url}' alt='#{name}' />"

Ember.Handlebars.helper 'small-flag', (country) ->
  code = country.get('code').toUpperCase()
  name = country.get('name')
  url = window.image_path("flags-iso/flat/24/#{code}.png")
  new Handlebars.SafeString "<img src='#{url}' alt='#{name}' />"
