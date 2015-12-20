Volant.MyMessagesRoute = Volant.MessagesRoute.extend
  viewName: 'messages'
  controllerName: 'messages'

  model: (params) ->
    user_id = @get('current_user.content.id')
    @store.find('message',user_id: user_id,p: params.page)

  setupController: (controller,model) ->
    @_super(controller,model)
    controller.set('myMessages',true)
