Volant.ApplicationRoute = Ember.Route.extend({
  model: ->
    @store.find('workcamp', { page: 0 })
})
