Volant.OrganizationRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('organization', params.organization_id)

})
