Volant.UserRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('user',params.user_id)

  actions:
    remove: ->
      @controller.get('model').destroyRecord().then(
        => @controller.transitionToRoute('users.index'),
        ->  console.error 'failed to delete the user')
      false
})
