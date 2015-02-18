Volant.NewWorkcampRoute = Volant.WorkcampRoute.extend

  viewName: 'workcamp'
  controllerName: 'workcamp'

  afterSave: (record) ->
    @transitionTo 'workcamps'
    @flash_info('Saved.')

  model: (params,transition) ->
    defaults = {
      language: 'English'
      minimal_age: 18
      maximal_age: 99
      places: 2
      places_for_males: 2
      places_for_females: 2
      publish_mode: 'SEASON'
      type: params.type
    }

    # like Hash#merge in JS
    opts = $.extend(defaults,transition.queryParams)
    @store.createRecord('workcamp', opts)
