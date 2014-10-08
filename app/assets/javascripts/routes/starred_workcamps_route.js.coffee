Volant.StarredWorkcampsRoute = Ember.Route.extend({
  model: ->
    @store.filter 'workcamp',{ starred: true }, (wc) ->
      wc.get('starred')
})
