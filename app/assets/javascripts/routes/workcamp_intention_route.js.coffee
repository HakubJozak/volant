Volant.WorkcampIntentionRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('workcamp_intention',params.workcamp_intention_id)
})
