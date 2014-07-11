Ember.Handlebars.helper 'image_path', (path) ->
  window.image_path(path)

Ember.Handlebars.helper 'flag', (country,size = 32) ->
  code = country.get('code').toUpperCase()
  name = country.get('name')
  url = window.image_path("flags-iso/flat/#{size}/#{code}.png")
  new Handlebars.SafeString "<img src='#{url}' alt='#{name}' />"
