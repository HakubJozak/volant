Volant.PaymentsRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('payment', { p: params.page })
})
