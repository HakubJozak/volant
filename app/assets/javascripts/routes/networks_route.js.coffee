Volant.NetworksRoute = Volant.BaseRoute.extend({
  model: ->
    @store.find('network')
})
