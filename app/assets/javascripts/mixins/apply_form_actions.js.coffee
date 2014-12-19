Volant.ApplyFormActions = Ember.Mixin.create({

  actions:
    apply_form_action: (action,form) ->
      switch action
        when 'pay'
          @controllerFor('apply_form').set('anchor','payment-fields')

        when 'cancel'
          url = "/apply_forms/#{form.get('id')}/cancel"
          @ajax_to_store(url).then (payload) =>
            @flash_info 'Application cancelled.'
        else
          @open_message_for(action,form)

  open_message_for: (action_name,apply_form) ->
    @store.find('user',@get('current_user.content.id')).then (user) =>
      apply_form.get('current_workcamp').then (workcamp) =>
        context = @message_context(user,apply_form,workcamp)
        console.log context

        message = @store.createRecord 'message', {
          subject: tmpl.eval_field('subject',context)
          body: tmpl.eval_field('body',context)
          from: tmpl.eval_field('from',context)
          to: tmpl.eval_field('to',context)
          cc: tmpl.eval_field('cc',context)
          bcc: tmpl.eval_field('bcc',context)
          action: action_name
          apply_form: apply_form
          user: user
          email_template: tmpl
        }

        message.save().then (msg) =>
          @transitionTo('message',msg)

    false


  message_context: (user,apply_form,workcamp) ->
    context = {}

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

})
