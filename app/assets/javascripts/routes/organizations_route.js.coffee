Volant.OrganizationsRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('organization', { page: 1 })

  actions:
    go_to_detail: (org) ->
      @transitionTo('organization',org)
})
