#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require handlebars
#= require ember
#= require ember-data
#= require images


#= require moment
## require moment/czech.js
## require moment/english.js
#= require modernizr
## require jquery-ui/datepicker
## require date-polyfill.min
#= require markdown

#= require_self
#= require ./store
#= require_tree ./mixins
#= require_tree ./models
#= require ./controllers/list_controller
#= require ./controllers/object_controller
#= require ./controllers/workcamp_controller
#= require_tree ./controllers
#= require ./views/field_view
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./components
#= require_tree ./templates
#= require ./routes/base_route
#= require_tree ./routes
#= require ./router


# Ember.Application.initializer({
#   name: "load-data",
#   after: "store",
#   initialize: (container) ->
#     Volant.deferReadiness()
#     Ember.$.getJSON "/workcamp_intentions.json", (json) ->
#       store = container.lookup('store:main')
#       store.load(Volant.WorkcampIntentions, json)
#       Volant.advanceReadiness()
# })

Ember.Application.initializer
  name: 'setCurrentUser'
  after: "store"

  initialize: (container,application) ->
    store = container.lookup('store:main')
    attributes = $('meta[name="current-user"]').attr('content')

    if attributes
      proxy_class = Volant.CurrentUserObjectProxy.extend()
      container.register 'user:current', proxy_class, singleton: true

      user = store.push('user', store.serializerFor(Volant.User).normalize(Volant.User, JSON.parse(attributes)))
      proxy = container.lookup('user:current')
      proxy.set('content', user)

      application.inject('controller', 'current_user', 'user:current');
      application.inject('route', 'current_user', 'user:current');

      # controller = container.lookup('controller:currentUser').set('content', user)
      # cannot inject controller onto other controllers?
      # container.injection('controller', 'current_user', 'controller:currentUser')


window.Volant = Ember.Application.create()
