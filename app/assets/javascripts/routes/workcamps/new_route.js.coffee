Volant.NewWorkcampRoute = Volant.WorkcampRoute.extend
  templateName: 'workcamp'
  controllerName: 'workcamp'

  model: (params,transition,queryParams) ->
    console.info 'p',params

    @store.createRecord('workcamp', {
      places: 2
      places_for_males: 2
      places_for_females: 2
      publish_mode: 'SEASON'
    })
