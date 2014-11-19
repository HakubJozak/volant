Volant.WorkcampIntentionsNewRoute = Volant.BaseRoute.extend({
  renderTemplate: ->
    @render('workcamp_intention')

  model: ->
    @store.createRecord('workcamp_intention')
})
