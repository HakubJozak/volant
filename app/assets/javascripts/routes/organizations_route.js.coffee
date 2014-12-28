Volant.OrganizationsRoute = Volant.BaseRoute.extend
  model: (params) ->
    @store.find('organization', { p: params.page,q: params.query })

  actions:
    search: ->
      @refresh()
