Volant.WorkcampRoute = Volant.BaseRoute.extend
  toolbar: 'workcamp/toolbar'

  model: (params) ->
    @store.find('workcamp', params.workcamp_id)

  title: (wc) ->
    "#{wc.get('name')} - #{wc.get('code')}"

  afterRemove: (record) ->
    @send 'goToWorkcamps'
    @flash_info('Deleted.')

  afterRollback: (record) ->
    @send 'goToWorkcamps'

  afterSave: (record,options = {}) ->
    @flash_info('Saved.')
    @send 'goToWorkcamps' if options.redirect

  actions:
    addBooking: ->
      @currentModel.addBooking()

    addApplyForm: (form) ->
      @send('createAssignment',@currentModel,form)
      false

    importVEF: ->
      @render 'apply_form/import_vef', outlet: 'modal', controller: 'apply_form_action_picker'
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
