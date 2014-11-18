Volant.CountriesRoute = Volant.BaseRoute.extend({
  model: ->
    @store.find('country')
})
