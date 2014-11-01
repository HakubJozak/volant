Volant.MessagesRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('message',user_id: @get('current_user.content.id'))
})
