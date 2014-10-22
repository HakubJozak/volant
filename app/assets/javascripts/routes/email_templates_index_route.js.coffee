Volant.EmailTemplatesRoute = Ember.Route.extend({
  model: ->
    @store.find 'email_template'
})
