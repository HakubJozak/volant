Volant.TagsNewRoute = Volant.BaseRoute.extend({
  renderTemplate: ->
    @render('Tag',model: @modelFor(@routeName))

  model: ->
    @store.createRecord('Tag',text_color: '#FFFFFF',color: '#c4c4c4')
})
