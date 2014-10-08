Volant.ApplyFormRoute = Volant.BaseRoute.extend({

  afterModel: (model) ->
    @transitionTo('workcamp_assignments',model)

  model: (params) ->
    @store.find('apply_form', params.apply_form_id)

  title: (model) -> "#{model.get('name')}"

  renderTemplate: ->
    @render('quick_save',into: 'application', outlet: 'item_controls')
    @render('apply_form')

  actions:
    view_workcamp: (wc) ->
      @transitionTo('workcamp',wc)

#  setupController: (controller, model) ->
#    @controllerFor('workcamps').set('current_item', model);
#    @_super(controller, model);

#  deactivate: ->
#    @controllerFor('workcamps').set('current_item', null);
})
