Volant.ApplyFormRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('apply_form', params.apply_form_id)

  actions:
    view_workcamp: (wc) ->
      @transitionTo('workcamp',wc)

#  setupController: (controller, model) ->
#    @controllerFor('workcamps').set('current_item', model);
#    @_super(controller, model);

#  deactivate: ->
#    @controllerFor('workcamps').set('current_item', null);
})
