Volant.NetworkRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('network',params.network_id)
})
