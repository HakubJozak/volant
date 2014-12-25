Volant.IncomingWorkcampsRoute = Volant.WorkcampsRoute.extend
  default_filter: -> { type: 'incoming' }

  controllerName: 'workcamps'
  templateName: 'workcamps'

  title: ->
    "Workcamps - Incoming"
