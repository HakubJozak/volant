Volant.WorkcampsNewRoute = Volant.WorkcampRoute.extend({
  model: ->
    @store.createRecord('workcamp', {
      places: 2
      places_for_males: 2
      places_for_females: 2
      publish_mode: 'SEASON'
    })

  renderTemplate: (controller,model) ->
    @controllerFor('workcamp').set('content',model)
    @render 'workcamp', into: 'application'

})
