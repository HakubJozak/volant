Volant.LtvApplyFormsRoute = Volant.ApplyFormsRoute.extend
  default_filter: -> { type: 'ltv' }
  newModelType: 'ltv'

  controllerName: 'apply_forms'
  templateName: 'apply_forms'

  title: ->
    "Applications - LTV"
