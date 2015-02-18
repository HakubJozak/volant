Volant.LtvWorkcampsRoute = Volant.WorkcampsRoute.extend
  default_filter: -> { type: 'ltv' }
  newWorkcampType: 'ltv'

  controllerName: 'workcamps'
  templateName: 'workcamps'

  afterSave: (record) ->
    @transitionTo 'ltv/workcamps'
    @flash_info('Saved.')

  title: ->
    "Workcamps - LTV"
