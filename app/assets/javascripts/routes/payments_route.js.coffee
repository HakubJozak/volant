Volant.PaymentsRoute = Volant.BaseRoute.extend
  model: (params) ->
    filter = { p: params.page,q: params.query, year: params.year  }
    filter.per_page = @controllerFor('pagination').get('perPage')
    @store.find('payment', filter)

  actions:
    search: ->
      @refresh()
      false

