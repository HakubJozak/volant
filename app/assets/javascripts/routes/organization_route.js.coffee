Volant.OrganizationRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('organization', params.organization_id)

  setupController: (controller,model) ->
    @_super(controller,model)
    @setup_mini_workcamps()

  actions:
    yearChanged: ->
      @setup_mini_workcamps()
      false

  setup_mini_workcamps: ->
    model = @modelFor(@routeName)
    year = @controllerFor('application').get('year')
    @store.find('workcamp',{ organization_id: model.get('id'),year: year }).then (orgs) =>
      @controllerFor('mini_workcamps').set('model', orgs);

})
