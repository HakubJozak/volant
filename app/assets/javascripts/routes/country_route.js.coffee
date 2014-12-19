Volant.CountryRoute = Volant.BaseRoute.extend({
  setupController: (controller,model,queryParams) ->
    @_super(controller,model,queryParams)
    @controllerFor('country_zones').set('content', @store.find('country_zone'))
  model: (params) ->
    @store.find('country',params.country_id)
})
