Volant.MessageUploadAttachmentController = Ember.ObjectController.extend Volant.Flash,
  actions:
    uploadAttachment: (attachment) ->
      @send 'closeModal'
      msg = @get('model')
      if msg.get('isNew')
        msg.save().then (saved_message) =>
          @_upload(saved_message)
          @transitionTo('message', saved_message)
      else
        @_upload(msg)
      false

  _upload: (msg) ->
    data = new FormData($('#upload-form')[0])
    data.append 'attachment[message_id]', msg.get('id')
    @send_files('/attachments',data).then ((response) =>
      @store.pushPayload(response)
      @flash_info('File uploaded.')
    ), =>
    @flash_error('Upload failed.')

  send_files: (url,data) ->
    new Promise (resolve, reject) =>
      csrf_token = $('meta[name="csrf-token"]').attr('content')
      csrf_param = $('meta[name="csrf-param"]').attr('content')
      data.append('authenticity_token',csrf_token)

      $.ajax
        url: url
        type: "POST"
        success: (response) =>
          resolve(response)

        error: (error) =>
          reject(error)

        data: data
        cache: false
        contentType: false
        processData: false
