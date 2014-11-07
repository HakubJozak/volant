Volant.MessageRoute = Volant.BaseRoute.extend({
  title: (model) -> "#{model.get('subject')}"

  model: (params) ->
    @store.find('message', params.message_id)

  setupController: (controller,model) ->
    @store.find('email_template').then (templates) =>
      @controllerFor('email_templates').set('content', templates)
    @_super(controller,model)

  actions:
    send_message: ->
      @modelFor(@routeName).save().then (msg) =>
        url = "/messages/#{msg.get('id')}/deliver"
        @ajax_to_store(url).then (payload) =>
          @flash_info 'Message sent.'
      false
})
