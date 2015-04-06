Ember.Handlebars.helper 'image_path', (path) ->
  window.image_path(path)

# Font Awesome icon
Ember.Handlebars.helper 'fa', (name) ->
  new Handlebars.SafeString "<i class='fa fa-#{name}'></i>"

Ember.Handlebars.helper 'fa-stack', (bottom,top) ->
        

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
