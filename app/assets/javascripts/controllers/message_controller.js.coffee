Volant.MessageController = Volant.ObjectController.extend({
  needs: [ 'email_templates' ]
  after_save_route: 'messages'

  emailTemplate: null

  process_markdown: (->
    if body = @get('body')
      @set('html_body',window.markdown.toHTML(body))
  ).observes('body')

  template_changed: (->
    @get('email_template').then (tmpl) =>
      if tmpl
        context = @message_context()
        @set 'body',tmpl.eval_field(field,context)
  ) # .observes('email_template')
})
