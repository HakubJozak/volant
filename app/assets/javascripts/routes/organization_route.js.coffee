Volant.OrganizationRoute = Volant.BaseRoute.extend
  model: (params) ->
    @store.find('organization', params.organization_id)

  setupController: (controller,model) ->
    @_super(controller,model)
    @setup_mini_workcamps()
    @controllerFor('networks').set('content', @store.filter('network',{},-> true))
    @currentModel.get('email_contacts').then (contacts) =>
      @controllerFor('email_contacts').set('model',contacts)

  actions:
    yearChanged: ->
      @setup_mini_workcamps()
      false

    newWorkcamp: ->
      org = @currentModel
      attrs = { organization: org, code: org.get('code') }
      @transitionTo 'new_workcamp','outgoing', {queryParams: attrs}
      false

  setup_mini_workcamps: ->
    unless @currentModel.get('isNew')
      year = @controllerFor('application').get('year')
      workcamps  = @store.filter('workcamp',{ organization_ids: [ @currentModel.get('id') ],year: year }, (wc) =>
        wc.get('organization.id') == @currentModel.get('id'))

      @controllerFor('mini_workcamps').set('model', workcamps)
