Volant.WorkcampRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('workcamp', params.workcamp_id)

  title: (wc) ->
    "#{wc.get('name')} - #{wc.get('code')}"

  renderTemplate: ->
    @_super()
    @render('quick_save',into: 'application', outlet: 'item_controls')
    @render('workcamp/page_up',into: 'application', outlet: 'page_up')

  actions:
    save: ->
      model = @modelFor(@routeName)
      model.get('errors').clear()
      model.save().then ( (wc) =>
         @transitionTo 'workcamp',model
         @flash_info 'Saved.'
       ), ( (e) =>
         @flash_error 'Failed.'
       )

    rollback: ->
      model = @modelFor(@routeName)
      model.get('errors').clear()
      model.rollback()
      false

  setupController: (controller,model,queryParams) ->
    @_super(controller,model,queryParams)
    @controllerFor('countries').set('content', @store.find('country'));
    @controllerFor('workcamp_intentions').set('content', @store.find('workcamp_intention'));
    @controllerFor('organizations').set('content', @store.find('organization'));
    @controllerFor('tags').set('content', @store.find('tag'));


#  setupController: (controller, model) ->
#    @controllerFor('workcamps').set('current_item', model);
#    @_super(controller, model);

#  deactivate: ->
#    @controllerFor('workcamps').set('current_item', null);
})
