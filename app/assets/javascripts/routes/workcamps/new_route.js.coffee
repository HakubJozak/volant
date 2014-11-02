Volant.WorkcampsNewRoute = Volant.BaseRoute.extend({
  model: ->
    @store.createRecord('workcamp', {
      places: 2,
      places_for_males: 2,
      places_for_females: 2,
    })

  renderTemplate: (controller,model) ->
    @controllerFor('workcamp').set('content',model)
    @render 'workcamp', into: 'application'

  actions:
    # not used
    save: ->
      model = @modelFor(@routeName)
      @modelFor(@routeName).save().then ( (wc) =>
         @transitionTo 'workcamp',model
         console.info 'saved'
       ), ( (e) ->
         console.error e
       )

    rollback: ->
      model = @modelFor(@routeName)
      model.get('errors').clear();
      model.rollback()
      false
})
