Volant.OrganizationsRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('organization', { page: 1 })
})
