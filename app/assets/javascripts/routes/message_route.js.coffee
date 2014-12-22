Volant.MessageRoute = Volant.BaseRoute.extend({
  title: (model) -> "#{model.get('subject')}"

  model: (params) ->
    if params.message_id != 'null'
      @store.find('message', params.message_id)
    else
      @transitionTo 'messages'

  setupController: (controller,model) ->
    @store.find('email_template').then (templates) =>
      tmpl = templates.findBy('action',model.get('action'))
      @controllerFor('email_templates').set('content',templates)
      controller.set('emailTemplate',tmpl)

      if model.get('isNew') && tmpl
        context = @message_context(model).then (context) ->
          console.log 'Message context', context
          model.set 'subject', tmpl.eval_field('subject',context)
          model.set 'html_body', tmpl.eval_field('body',context)
          model.set 'from', tmpl.eval_field('from',context)
          model.set 'to', tmpl.eval_field('to',context)
          model.set 'cc', tmpl.eval_field('cc',context)
          model.set 'bcc', tmpl.eval_field('bcc',context)
      else
        console.info 'sheet'

    @_super(controller,model)

  message_context: (model) ->
    model.get('apply_form').then (apply_form) =>
      apply_form.get('current_workcamp').then (workcamp) =>
        context = {}
        user = model.get('user')

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
    send_message: ->
      @currentModel.save().then (msg) =>
        url = "/messages/#{msg.get('id')}/deliver"
        @ajax_to_store(url).then ((payload) =>
          @flash_info 'Message sent.'),
        =>
          @flash_error 'Send failed'
      false
})
