Volant.Router.map () ->
  @resource 'workcamps', ->
    @resource('workcamp', path: '/workcamps/:workcamp_id')
  @resource('forms')


Volant.ApplicationRoute = Ember.Route.extend({

})


Volant.ApplicationController = Ember.ObjectController.extend({
  # fake data for now
  current_user:
    name: 'Jakub Hozak'
})

Volant.ApplicationView = Ember.View.extend({
  layoutName: 'layout'
})


Volant.WorkcampsRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('workcamp', { page: 1 })
})

Volant.WorkcampRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('workcamp', params.workcamp_id)

  setupController: (controller, model) ->
    @controllerFor('workcamps').set('current_item', model);
    @_super(controller, model);

  deactivate: ->
    @controllerFor('workcamps').set('current_item', null);
})

# Volant.WorkcampsPagesRoute = Ember.Route.extend({
#   model: (params) ->
#     Ember.Object.create id: params.page_id
# })
