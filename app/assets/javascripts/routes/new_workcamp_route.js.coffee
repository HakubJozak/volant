Volant.NewWorkcampRoute = Volant.WorkcampRoute.extend
  templateName: 'workcamp'
  controllerName: 'workcamp'

  model: (params,transition) ->
    defaults = {
      places: 2
      places_for_males: 2
      places_for_females: 2
      capacity: 8
      capacity_males: 4
      capacity_females: 4
      capacity_natives: 2
      publish_mode: 'SEASON'
      type: params.type
    }

    # like Hash#merge in JS
    opts = $.extend(defaults,transition.queryParams)
    @store.createRecord('workcamp', opts)
