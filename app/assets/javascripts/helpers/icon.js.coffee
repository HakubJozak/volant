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

Ember.Handlebars.helper 'button', (label,action_name,clazz) ->
   # slice the passed arguments away
   args = Array.prototype.slice.call(arguments, 3);
   args.unshift(action_name);
   action = Ember.Handlebars.helpers.action.apply(this,args)

   html = """
          <button type="button" class="btn #{clazz}" #{action}>
            #{label}
          </button>
         """

   new Handlebars.SafeString(html)
