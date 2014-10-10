Volant.PaymentsRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('payment', { p: params.page, year: params.year })

  actions:
    search: ->
      @refresh()
      false

})
