Volant.LtvApplyFormsRoute = Volant.ApplyFormsRoute.extend
  default_filter: -> { type: 'ltv' }
  newModelType: 'ltv'

  afterSave: (record) ->
    @transitionTo 'ltv/apply_forms'
    @flash_info('Saved.')

  controllerName: 'apply_forms'
  templateName: 'apply_forms'

  title: ->
    "Applications - LTV"
