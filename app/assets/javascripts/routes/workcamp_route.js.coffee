Volant.WorkcampRoute = Volant.BaseRoute.extend Volant.SendFiles,
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

    openVefDialog: ->
      @render 'apply_form/import_vef', outlet: 'modal', controller: 'apply_form_action_picker'
      false

    uploadVef: ->
      data  = new FormData($('#vef-upload-form')[0])
      wc_id = @currentModel.get('id')
      @send_files("/workcamps/#{wc_id}/vefs", data).then ((response) =>
        @send 'closeModal'
        @store.pushPayload(response)
        @currentModel.reload()
        @flashInfo('VEF imported.')
      ), (e) =>
        @send 'closeModal'
        @flashError(e.responseJSON.errors)
      false

    cancel_import: ->
      id = @currentModel.get('id')
      url = "/workcamps/#{id}/cancel_import"
      @ajax_to_store(url).then ((payload) =>
        @transitionTo('imported_workcamps')
        @flashInfo 'Import cancelled.'),
         =>
        @flashError 'Action failed'
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
