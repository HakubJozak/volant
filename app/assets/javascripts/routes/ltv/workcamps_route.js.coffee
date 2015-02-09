Volant.LtvWorkcampsRoute = Volant.WorkcampsRoute.extend
  default_filter: -> { type: 'ltv' }
  newWorkcampType: 'ltv'

  controllerName: 'workcamps'
  templateName: 'workcamps'

  title: ->
    "Workcamps - LTV"
