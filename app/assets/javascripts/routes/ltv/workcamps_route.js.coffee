Volant.LtvWorkcampsRoute = Volant.WorkcampsRoute.extend
  default_filter: -> { type: 'ltv' }

  controllerName: 'workcamps'
  templateName: 'workcamps'

  model: (params) ->
    # Longterm workcamps are not bound by year
    delete params.year
    @_super(params)

  title: ->
    "Workcamps - LTV"
