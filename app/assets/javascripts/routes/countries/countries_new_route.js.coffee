Volant.CountriesNewRoute = Volant.BaseRoute.extend({
  renderTemplate: ->
    @render('country')

  model: ->
    @store.createRecord('country')
})
