Volant.ImportedWorkcampRoute = Volant.WorkcampRoute.extend
  viewName: 'workcamp'
  controllerName: 'workcamp'

  afterSave: (wc) ->
    @transitionTo('imported_workcamps')

  afterRollback: (wc) ->
    @transitionTo('imported_workcamps')

  afterRemove: (wc) ->
    @transitionTo('imported_workcamps')
