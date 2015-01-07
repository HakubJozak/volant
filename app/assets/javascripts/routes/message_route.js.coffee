Volant.MessageRoute = Volant.BaseRoute.extend
  title: (model) -> "#{model.get('subject')}"

  model: (params) ->
    if params.message_id != 'null'
      @store.find('message', params.message_id)
    else
      @transitionTo 'messages'

  setupController: (controller,message) ->
    @store.find('email_template').then (templates) =>
      tmpl = templates.findBy('action',message.get('action'))
      @controllerFor('email_templates').set('content',templates)
      controller.set('selectedTemplate',tmpl)

      if message.get('isNew') && tmpl
        @applyTemplate(tmpl,message)

    @_super(controller,message)

  applyTemplate: (tmpl,message) ->
    context = @message_context(message).then (context) ->
      console.log 'Message context', context
      message.set 'subject', tmpl.eval_field('subject',context)
      message.set 'html_body', tmpl.eval_field('body',context)
      message.set 'from', tmpl.eval_field('from',context)
      message.set 'to', tmpl.eval_field('to',context)
      message.set 'cc', tmpl.eval_field('cc',context)
      message.set 'bcc', tmpl.eval_field('bcc',context)

  message_context: (message) ->
    message.get('apply_form').then (apply_form) =>
      apply_form.get('current_workcamp').then (workcamp) =>
        context = {}
        user = message.get('user')

        if user
          context.user = user.for_email()

        if apply_form
          context.apply_form = apply_form.for_email()

          if volunteer = apply_form.get('volunteer')
            context.volunteer = volunteer.for_email()

        if workcamp
          context.workcamp = workcamp.for_email()
          # legacy alias
          context.wc = context.workcamp

          if org = workcamp.get('organization')
            context.organization = org.for_email()
        context


  actions:
    useTemplate: (tmpl) ->
      @applyTemplate(tmpl,@currentModel)
      false

    sendMessage: ->
      @currentModel.save().then (msg) =>
        form = msg.get('apply_form')
        url = "/messages/#{msg.get('id')}/deliver"
        @ajax_to_store(url).then ((payload) =>
          @transitionTo('apply_form', form) if form
          @flash_info 'Message sent.'),
        =>
          @flash_error 'Send failed'
      false

    uploadAttachment: (attachment) ->
      data = new FormData($('#upload-form')[0])
      data.append 'attachment[message_id]', @currentModel.get('id')
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

  
