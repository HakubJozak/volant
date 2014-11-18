Volant.CountryRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('country',params.country_id)
})
