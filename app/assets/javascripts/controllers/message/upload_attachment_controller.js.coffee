Volant.MessageUploadAttachmentController = Ember.ObjectController.extend Volant.Flash, Volant.SendFiles,
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

