Volant.OrganizationsRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('organization', { page: 1 })
})
