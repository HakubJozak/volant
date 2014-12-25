Volant.OrganizationsRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('organization', { p: params.page })

  actions:
    search: ->
      @refresh()
})
