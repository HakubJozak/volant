Volant.WorkcampRoute = Volant.BaseRoute.extend
  model: (params) ->
    @store.find('workcamp', params.workcamp_id)

  title: (wc) ->
    "#{wc.get('name')} - #{wc.get('code')}"

  setupController: (controller,model,queryParams) ->
    @_super(controller,model,queryParams)
    @controllerFor('starred_apply_forms').set('content', @store.find('apply_form',starred: true));
    @prepareSelectControllers()

  actions:
    addApplyForm: (form) ->
      @send('createAssignment',@currentModel,form)
      false

    cancel_import: ->
      id = @currentModel.get('id')
      url = "/workcamps/#{id}/cancel_import"
      @ajax_to_store(url).then ((payload) =>
        @transitionTo('imported_workcamps')
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
