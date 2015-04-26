Volant.MessageRoute = Volant.BaseRoute.extend
  templateName: 'message'
  controllerName: 'message'
  toolbar: 'message/toolbar'

  title: (model) -> "#{model.get('subject')}"

  afterSave: (msg) ->
    @flash_info('Message saved.')
    @transitionTo 'message',msg.get('id')

  model: (params) ->
    if params.message_id != 'null'
      @store.find('message', params.message_id)
    else
      @transitionTo 'messages'

  setupController: (controller,message) ->
    data =
      templates: @store.find('email_template')
      applyForm: message.get('applyForm')
      workcamp: message.get('applyForm.currentWorkcamp')

    Ember.RSVP.hash(data).then (r) =>
      name = @_templateNameFor(message, r.applForm)
      tmpl = r.templates.findBy('action',name)
      workcamp = message.get('workcamp') || r.workcamp

      @controllerFor('email_templates').set('content',r.templates)
      controller.set('selectedTemplate',tmpl)

      if message.get('isNew') && tmpl
        @applyTemplate(tmpl,message,r.applyForm,workcamp)

    @_super(controller,message)

  applyTemplate: (tmpl,message,applyForm,workcamp) ->
    evalError = (e) =>
      console.error(e)
      @flash_error(e)

    context = @_message_context(message,applyForm,workcamp)
    message.set 'subject', tmpl.eval_field('subject',context, evalError)
    message.set 'html_body', tmpl.eval_field('body',context, evalError)
    message.set 'from', tmpl.eval_field('from',context, evalError)
    message.set 'to', tmpl.eval_field('to',context, evalError)
    message.set 'cc', tmpl.eval_field('cc',context, evalError)
    message.set 'bcc', tmpl.eval_field('bcc',context, evalError)

  _templateNameFor: (message,form) ->
    action = message.get('action')
    resource = form || message.get('workcamp')
    return action unless resource

    type = resource.get('type')

    if type == 'outgoing'
      action
    else
      "#{type}/#{action}"

  _message_context: (message,applyForm,workcamp) ->
    context = {}
    user = message.get('user')

    if user
      context.user = user.for_email()

    if applyForm
      context.application = applyForm.for_email()
      # legacy aliases
      context.applyForm = context.application
      context.apply_form = context.application

      if volunteer = applyForm.get('volunteer')
        context.volunteer = volunteer.for_email()

    if workcamp
      context.workcamp = workcamp.for_email()
      # legacy alias
      context.wc = context.workcamp

      if org = workcamp.get('organization')
        context.organization = org.for_email()

    console.debug 'Message context:',context
    context

  actions:
    useTemplate: (tmpl) ->
      @currentModel.get('apply_form').then (apply_form) =>
        @applyTemplate(tmpl,@currentModel,apply_form)
      false

    sendMessage: ->
      @currentModel.save().then (msg) =>
        form = msg.get('apply_form')
        url = "/messages/#{msg.get('id')}/deliver"
        @ajax_to_store(url).then ((payload) =>
          @flash_info 'Message sent.'),
          @send 'goToApplyForms'
        (e) =>
          @flash_error 'Send failed.'
      false

    showUploadDialog: ->
      @render 'message/upload_attachment',outlet: 'modal',model: @currentModel, controller: 'message_upload_attachment'
      false

    destroyAttachment: (attachment) ->
      console.log 'Attachment destroyed.'
      attachment.destroyRecord()
      false
