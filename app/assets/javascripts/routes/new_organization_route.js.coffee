Volant.NewOrganizationRoute = Volant.OrganizationRoute.extend
  templateName: 'organization'
  controllerName: 'organization'

  model: (params) ->
    @store.createRecord('organization')
