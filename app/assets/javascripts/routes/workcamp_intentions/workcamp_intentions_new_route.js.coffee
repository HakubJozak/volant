Volant.WorkcampIntentionsNewRoute = Volant.BaseRoute.extend({
  renderTemplate: ->
    @render('workcamp_intention',model: @modelFor(@routeName))

  model: ->
    @store.createRecord('workcamp_intention')
})
