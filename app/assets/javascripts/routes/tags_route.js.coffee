Volant.TagsRoute = Volant.BaseRoute.extend({
  model: ->
    @store.find('tag')
})
