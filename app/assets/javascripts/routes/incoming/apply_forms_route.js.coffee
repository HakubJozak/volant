Volant.IncomingApplyFormsRoute = Volant.ApplyFormsRoute.extend
  default_filter: -> { type: 'incoming' }
  newModelType: 'incoming'

  controllerName: 'apply_forms'
  templateName: 'apply_forms'

  title: ->
    "VEFs - Incoming"
