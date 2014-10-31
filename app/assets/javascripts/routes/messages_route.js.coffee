Volant.MessagesRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('user',@get('current_user.content.id')).then (user) ->
      console.info 'asdf'
      user.get('messages')
})
