Volant.UsersController = Ember.ArrayController.extend({
  actions:
    go_to_detail: (user) ->
      @transitionToRoute('user',user)
})
