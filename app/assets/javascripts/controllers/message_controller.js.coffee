Volant.MessageController = Volant.ObjectController.extend({
  needs: 'email_templates'
  after_save_route: 'messages'

  process_markdown: (->
    if body = @get('body')
      @set('html_body',window.markdown.toHTML(body))
  ).observes('body')

})
