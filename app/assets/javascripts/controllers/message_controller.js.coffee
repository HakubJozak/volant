Volant.MessageController = Volant.ObjectController.extend({
  needs: 'email_templates'
  after_save_route: 'messages'

  process_markdown: (->
    @set('html_body',window.markdown.toHTML(@get('body')))
  ).observes('body')

})
