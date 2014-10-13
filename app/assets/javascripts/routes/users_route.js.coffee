Volant.UsersRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('user')
})
