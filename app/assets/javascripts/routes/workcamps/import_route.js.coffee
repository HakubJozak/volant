Volant.WorkcampsImportRoute = Ember.Route.extend({
  actions:
    import: ->
      data = new FormData($('#upload-form')[0])
      @send_files('/workcamps/import',data).then (-> console.info 'cool' ), ((e) -> console.error e )
      false

  send_files: (url,data = {}) ->
    new Promise (resolve, reject) =>
      csrf_token = $('meta[name="csrf-token"]').attr('content')
      csrf_param = $('meta[name="csrf-param"]').attr('content')

      data = new FormData($('#upload-form')[0])
      data.append('authenticity_token',csrf_token)

      try
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
            @store.pushPayload(response)
            resolve(response)

          error: (error) =>
            reject(error)

          # Form data
          data: data

          cache: false
          contentType: false
          processData: false
      catch e
        reject(e)

      console.info

})
