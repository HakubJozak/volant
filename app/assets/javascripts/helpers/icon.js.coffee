Ember.Handlebars.helper 'image_path', (path) ->
  window.image_path(path)

Ember.Handlebars.helper 'flag', (country) ->
  return unless country
  code = country.get('code').toUpperCase()
  name = country.get('name')
  url = window.image_path("flags-iso/flat/32/#{code}.png")
  new Handlebars.SafeString "<img src='#{url}' alt='#{name}' />"

# Font Awesome icon
Ember.Handlebars.helper 'fa', (name) ->
  new Handlebars.SafeString "<i class='fa fa-#{name}'></i>"

Ember.Handlebars.helper 'fa-link', (name) ->
  new Handlebars.SafeString "<a href='#'><i class='fa fa-#{name}'></i></a>"
