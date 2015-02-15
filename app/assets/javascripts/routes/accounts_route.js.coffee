Volant.AccountsRoute = Volant.BaseRoute.extend({
  model: ->
    @store.find('account')
})
