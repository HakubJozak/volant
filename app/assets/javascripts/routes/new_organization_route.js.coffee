Volant.NewOrganizationRoute = Volant.OrganizationRoute.extend
  templateName: 'organization'
  controllerName: 'organization'

  afterSave: (record) ->
    @transitionTo 'organization',record
    @flash_info 'Organization saved.'

  model: (params) ->
    @store.createRecord('organization')
