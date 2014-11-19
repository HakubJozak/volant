Volant.WorkcampIntentionsRoute = Volant.BaseRoute.extend({
  model: ->
    @store.find('workcamp_intention')
})
