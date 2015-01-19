Volant.NetworksNewRoute = Volant.BaseRoute.extend({
  renderTemplate: ->
    @render('network',model: @modelFor(@routeName))

  model: ->
    @store.createRecord('network')
})
