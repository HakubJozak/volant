Volant.ImportedWorkcampsRoute = Volant.WorkcampsRoute.extend({
  controllerName: 'workcamps'
  templateName: 'workcamps'

  title: -> "Imported Workcamps"
  default_filter: -> { state: 'imported' }
})
