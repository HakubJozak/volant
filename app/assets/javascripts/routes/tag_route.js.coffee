Volant.TagRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('Tag',params.Tag_id)
})
