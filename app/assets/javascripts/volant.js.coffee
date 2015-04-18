#= require jquery
#= require jquery.cookie
#= require jquery_ujs
#= require twitter/bootstrap
#= require handlebars
#= require ember
#= require ember-data
#= require moment
#= require moment/cs
#= require moment/en-au
#= require jquery.ui.datepicker
#= require modernizr
#= require date-polyfill/date-polyfill.min
#= require markdown
#= require Chart
#= require barbecue

#= require ./images
#= require_self
#= require ./fa_icon_names

#= require_tree ./adapters
#= require_tree ./serializers
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
#= require ./routes/organization_route
#= require ./routes/workcamp_route
#= require ./routes/workcamps_route
#= require_tree ./routes
#= require ./router


#
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

moment.locale('en-au')


          

Ember.Application.initializer
  name: 'setCurrentUser'
  after: "store"

  initialize: (container,application) ->
    store = container.lookup('store:main')
    attributes = $('meta[name="current-user"]').attr('content')
    json = JSON.parse(attributes)

    if attributes
      proxy_class = Volant.CurrentUserObjectProxy.extend()
      container.register 'user:current', proxy_class, singleton: true

#      user = store.push('user', store.serializerFor(Volant.User).normalize(Volant.User, JSON.parse(attributes)))
      store.pushPayload('user',json)
      store.find('user',json.user.id).then (user) =>
        proxy = container.lookup('user:current')
        proxy.set('content', user)

      application.inject('controller', 'current_user', 'user:current');
      application.inject('route', 'current_user', 'user:current');

      # controller = container.lookup('controller:currentUser').set('content', user)
      # cannot inject controller onto other controllers?
      # container.injection('controller', 'current_user', 'controller:currentUser')

window.Volant = Ember.Application.create()

window.Volant.saveSettings = (name,value) ->
  Volant.settings[name] = value
  console.log 'Saving settings: ', name,value
  json = JSON.stringify(Volant.settings)
  $.cookie('volant-settings',json)

# load settings
if s = $.cookie('volant-settings')
  Volant.settings = JSON.parse(s)
  console.log 'Settings loaded'
else
  console.log 'Using default default settings'
  Volant.settings = {
    mode: 'outgoing'
    perPage: 15
  }

console.log Volant.settings

