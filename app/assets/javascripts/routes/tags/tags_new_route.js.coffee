Volant.TagsNewRoute = Volant.BaseRoute.extend({
  renderTemplate: ->
    @render('Tag',model: @modelFor(@routeName))

  model: ->
    @store.createRecord('Tag')
})
