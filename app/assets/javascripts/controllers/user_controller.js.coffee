Volant.UserController = Volant.ObjectController.extend({
  after_save_route: 'users.index'

  actions:
    rollback: ->
      @_super()
      @transitionToRoute('users.index')
      false
})
