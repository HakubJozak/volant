Volant.AccountsNewRoute = Volant.BaseRoute.extend({
  renderTemplate: ->
    @render('account',model: @modelFor(@routeName))

  model: ->
    @store.createRecord('account')
})
