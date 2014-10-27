Volant.MessagingRouteMixin = Ember.Mixin.create({

  actions:
    open_existing_message: (apply_form) ->
      message = apply_form.get('message')
      @controllerFor('message').set('content',message)
      @render 'message', into: 'application',outlet: 'modal'
      false


  open_message_for: (action_name,apply_form) ->
    @store.find('email_template').then (templates) =>
      @controllerFor('email_templates').set('content', templates)
      tmpl = templates.findBy('action',action_name)

      @store.find('user',@get('current_user.content.id')).then (user) =>
        message = @store.createRecord 'message', {
          from: user.get('email')
          to: apply_form.get('email')
          bcc: user.get('email')
#          to: apply_form.get('current_workcamp.organization.outgoing_email')
          action: action_name
          apply_form: apply_form
          user: user
          email_template: tmpl
        }

        @controllerFor('message').set('content',message)

    @render 'message', into: 'application',outlet: 'modal'
    false
})
