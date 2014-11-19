Volant.TagsNewRoute = Volant.BaseRoute.extend({
  renderTemplate: ->
    @render('tag')

  model: ->
    @store.createRecord('tag')
})
