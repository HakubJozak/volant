Volant.ImportedWorkcampsRoute = Volant.WorkcampsRoute.extend
  title: -> "Imported Workcamps"
  default_filter: -> { state: 'imported' }

  model: (params) ->
    @store.find 'workcamp', state: 'imported', p: params.page
    # @store.filter 'workcamp', state: 'imported', (wc) ->
    #   state = wc.get('state')
    #   state == 'imported' or state == 'updated'

  actions:
    confirmAll: ->
      @ajax_to_store('/workcamps/confirm_all').then(@_success('All changes confirmed.'),@_error)
      false

    cancelAll: ->
      @ajax_to_store('/workcamps/cancel_all').then(@_success('All changes cancelled.'),@_error)
      false

    import: ->
      data = new FormData($('#upload-form')[0])

      @controllerFor('imported_workcamps').set('messages',[])
      @_send_files('/workcamps/import',data).then ( (messages) =>
        @controllerFor('imported_workcamps').set('messages',messages)
        @flash_info('Import finished. See the results below.')
        @refresh()
        ), ((e) =>
        @flash_error('Import failed.') )
      false

  # --- private ---

  _success: (msg) ->
    @flash_info(msg)
    @refresh()

  _error: ->
    @flash_error('Action failed.')
    @refresh()

  _send_files: (url,data = {}) ->
    new Promise (resolve, reject) =>
      csrf_token = $('meta[name="csrf-token"]').attr('content')
      csrf_param = $('meta[name="csrf-param"]').attr('content')

      data = new FormData($('#upload-form')[0])
      data.append('authenticity_token',csrf_token)
      data.append('type',@get('controller.mode'))

      $.ajax
        url: url
        type: "POST"
        # xhr: -> # Custom XMLHttpRequest
        #   myXhr = $.ajaxSettings.xhr()
        #   # Check if upload property exists
        #   myXhr.upload.addEventListener "progress", progressHandlingFunction, false  if myXhr.upload # For handling the progress of the upload
        #   myXhr

        #Ajax events
        # beforeSend: beforeSendHandler
        success: (response) =>
          if response.import_messages
            messages = response.import_messages.map (attrs) ->
              Ember.Object.create(attrs)
            resolve(messages)
          else
            reject('Missing import information.')

        error: (error) =>
          reject(error)

        # Form data
        data: data

        cache: false
        contentType: false
        processData: false
