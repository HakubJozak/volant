Volant.WorkcampRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('workcamp', params.workcamp_id)

  title: (wc) ->
    "#{wc.get('name')} - #{wc.get('code')}"

  renderTemplate: ->
    @_super()
    @render('quick_save',into: 'application', outlet: 'item_controls')
    @render('workcamp/page_up',into: 'application', outlet: 'page_up')

  setupController: (controller,model,queryParams) ->
    @_super(controller,model,queryParams)
    @controllerFor('countries').set('content', @store.find('country'));
    @controllerFor('workcamp_intentions').set('content', @store.find('workcamp_intention'));
    @controllerFor('organizations').set('content', @store.find('organization'));
    @controllerFor('tags').set('content', @store.find('tag'));

  actions:
    cancel_import: ->
      id = @currentModel.get('id')
      url = "/workcamps/#{id}/cancel_import"
      @ajax_to_store(url).then ((payload) =>
        @flash_info 'Import cancelled.'),
         =>
        @flash_error 'Action failed'
      false

    confirm_import: ->
      @currentModel.get('import_changes').forEach (change) ->
        change.apply()
      @currentModel.save().then =>
        id = @currentModel.get('id')
        url = "/workcamps/#{id}/confirm_import"
        @ajax_to_store(url).then ((payload) =>
          @flash_info 'Import confirmed.'
          @transitionTo('imported_workcamps')
        ),
        =>
          @flash_error 'Import failed.'
      false

#  setupController: (controller, model) ->
#    @controllerFor('workcamps').set('current_item', model);
#    @_super(controller, model);

#  deactivate: ->
#    @controllerFor('workcamps').set('current_item', null);
})
