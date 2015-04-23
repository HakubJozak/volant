Volant.VolunteersRoute = Volant.BaseRoute.extend
  model: (params) ->
    filter = { q: params.query, p: params.page }
    filter.per_page = @controllerFor('pagination').get('perPage')
    @store.find('volunteer', filter)

  actions:
    search: ->
      @refresh()
      false
