Volant.WorkcampRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('workcamp', params.workcamp_id)

  title: (wc) ->
    "#{wc.get('code')} - #{wc.get('name')}"

  renderTemplate: ->
    @render('quick_save',into: 'application', outlet: 'item_controls')
    @render('workcamp')

  deactivate: ->
    console.info 'deactivated'

  actions:
    view_apply_form: (form) ->
      @transitionTo('apply_form',form)

#  setupController: (controller, model) ->
#    @controllerFor('workcamps').set('current_item', model);
#    @_super(controller, model);

#  deactivate: ->
#    @controllerFor('workcamps').set('current_item', null);
})
