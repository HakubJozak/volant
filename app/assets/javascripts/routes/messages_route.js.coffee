Volant.MessagesRoute = Volant.BaseRoute.extend
  model: (params) ->
    user_id = @get('current_user.content.id')
    @store.find('message',user_id: user_id,p: params.page)

  actions:
    search: ->
      @refresh()

