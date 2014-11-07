Volant.VolunteersRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('volunteer', { q: params.query, p: params.page })
})
