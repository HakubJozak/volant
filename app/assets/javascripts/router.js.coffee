Volant.Router.map () ->
  @resource 'workcamps'
  @resource('workcamp', path: '/workcamps/:workcamp_id')
  @resource('forms')


Volant.ApplicationRoute = Ember.Route.extend({
})

Volant.WorkcampsRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('workcamp', { page: 1 })
})

Volant.WorkcampRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('workcamp', params.workcamp_id)
})

# Volant.WorkcampsPagesRoute = Ember.Route.extend({
#   model: (params) ->
#     Ember.Object.create id: params.page_id
# })
