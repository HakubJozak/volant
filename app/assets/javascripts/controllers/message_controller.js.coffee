Volant.MessageController = Volant.ObjectController.extend({
  needs: [ 'email_templates' ]
  after_save_route: 'messages'
  editable: Ember.computed.not('delivered')

  emailTemplate: null

  template_changed: (->
    @get('email_template').then (tmpl) =>
      if tmpl
        context = @message_context()
        @set 'body',tmpl.eval_field(field,context)
  ) # .observes('email_template')
})
