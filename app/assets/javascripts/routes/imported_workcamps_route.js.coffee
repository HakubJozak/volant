Volant.ImportedWorkcampsRoute = Volant.WorkcampsRoute.extend
  controllerName: 'workcamps'
  title: -> "Imported Workcamps"
  default_filter: -> { state: 'imported' }

  model: (params) ->
    @store.find 'workcamp', state: 'imported'
    # @store.filter 'workcamp', state: 'imported', (wc) ->
    #   state = wc.get('state')
    #   state == 'imported' or state == 'updated'

  actions:
    import: ->
      data = new FormData($('#upload-form')[0])
      @controllerFor('imported_workcamps').set('messages',[])
      @send_files('/workcamps/import',data).then ( (messages) =>
        @controllerFor('imported_workcamps').set('messages',messages)
        @flash_info('Import succesful')
        @refresh()
        ), ((e) =>
        @flash_error('Import failed') )
      false

  # --- private ---

  send_files: (url,data = {}) ->
    new Promise (resolve, reject) =>
      csrf_token = $('meta[name="csrf-token"]').attr('content')
      csrf_param = $('meta[name="csrf-param"]').attr('content')

      data = new FormData($('#upload-form')[0])
      data.append('authenticity_token',csrf_token)

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
