Volant.TagsNewRoute = Volant.BaseRoute.extend({
  renderTemplate: ->
    @render('tag',model: @modelFor(@routeName))

  model: ->
    @store.createRecord('tag')
})
