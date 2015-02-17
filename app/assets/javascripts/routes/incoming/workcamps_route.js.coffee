Volant.IncomingWorkcampsRoute = Volant.WorkcampsRoute.extend
  default_filter: -> { type: 'incoming' }
  newWorkcampType: 'incoming'

  controllerName: 'workcamps'
  templateName: 'workcamps'

  afterSave: (record) ->
    @transitionTo('incoming/workcamps')
    @flash_info('Saved.')

  title: ->
    "Workcamps - Incoming"
