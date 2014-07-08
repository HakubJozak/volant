Volant.ApplicationRoute = Ember.Route.extend({
  model: ->
    @store.query('workcamp', { page: 0 })
})
