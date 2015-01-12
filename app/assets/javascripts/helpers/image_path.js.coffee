Ember.Handlebars.helper 'image_path', (path) ->
  window.image_path(path)

# TODO: replace by SVG rectangular icons
# https://github.com/lipis/flag-icon-css
Ember.Handlebars.helper 'flag', (country) ->
  return unless country
  code = country.get('code').toUpperCase()
  name = country.get('name')
  url = window.image_path("flags-iso/flat/32/#{code}.png")
  new Handlebars.SafeString "<img src='#{url}' alt='#{name}' />"

Ember.Handlebars.helper 'small-flag', (country) ->
  return unless country
  code = country.get('code').toUpperCase()
  name = country.get('name')
  url = window.image_path("flags-iso/flat/24/#{code}.png")
  new Handlebars.SafeString "<img class='flag' src='#{url}' alt='#{name}' />"
