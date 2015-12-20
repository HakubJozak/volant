Volant.MessagesRoute = Volant.BaseRoute.extend
  model: (params) ->
    @store.find('message',p: params.page)

  setupController: (controller,model) ->
    @_super(controller,model)
    controller.set('myMessages',false)

  actions:
    search: ->
      @refresh()
