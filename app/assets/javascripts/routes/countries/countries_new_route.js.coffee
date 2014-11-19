Volant.CountriesNewRoute = Volant.BaseRoute.extend({
  renderTemplate: ->
    @render('country',model: @modelFor(@routeName))

  model: ->
    @store.createRecord('country')
})
