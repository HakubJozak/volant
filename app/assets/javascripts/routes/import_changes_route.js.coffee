Volant.ImportChangesRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('import_change',workcamp_id: params.workcamp_id)
})
