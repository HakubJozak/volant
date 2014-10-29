Volant.MessageRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('message', params.message_id)

  setupController: (controller,model) ->
    @store.find('email_template').then (templates) =>
      @controllerFor('email_templates').set('content', templates)
    @_super(controller,model)

  actions:
    send_message: ->
      @modelFor(@routeName).save().then (msg) =>
        msg.deliver().then (payload) =>
          @controllerFor('flash').set('content', 'Message sent.')
          @store.pushPayload(payload)

})
