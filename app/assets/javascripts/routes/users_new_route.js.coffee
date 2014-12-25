Volant.UsersNewRoute = Volant.BaseRoute.extend
  model: ->
    @store.createRecord('user')
