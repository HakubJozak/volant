Volant.WorkcampRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('workcamp', params.workcamp_id)

  renderTemplate: ->
    @render('quick_save',into: 'application', outlet: 'item_controls')
    @render('workcamp')

  actions:
    view_apply_form: (form) ->
      @transitionTo('apply_form',form)

#  setupController: (controller, model) ->
#    @controllerFor('workcamps').set('current_item', model);
#    @_super(controller, model);

#  deactivate: ->
#    @controllerFor('workcamps').set('current_item', null);
})
