Volant.OrganizationsRoute = Volant.BaseRoute.extend
  model: (params) ->
    filter = { p: params.page,q: params.query }
    filter.per_page = @controllerFor('pagination').get('perPage')
    @store.find('organization', filter)

  actions:
    search: ->
      @refresh()
