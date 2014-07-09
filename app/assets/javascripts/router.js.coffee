Volant.Router.map () ->
  @resource 'workcamps', ->
    @resource('page', path: '/page/:page')
  @resource('forms')


Volant.ApplicationRoute = Ember.Route.extend({
})

Volant.WorkcampsRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('workcamp', { page: 1 })
})

# Volant.WorkcampsPagesRoute = Ember.Route.extend({
#   model: (params) ->
#     Ember.Object.create id: params.page_id
# })
