Volant.NewWorkcampMessageRoute = Volant.MessageRoute.extend
  afterSave: (record) ->
    debugger
    @transitionTo 'message',record
    @flash_info 'Message saved.'

  model: (params) ->
    action_name = params.action_name

    @store.find('user',@get('current_user.content.id')).then (user) =>
      @store.find('workcamp',params.workcamp_id).then (workcamp) =>

        msg = @store.createRecord 'message', {
          action: action_name
          workcamp: workcamp
          user: user
        }

        msg
