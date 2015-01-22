Volant.NewApplyFormRoute = Volant.ApplyFormRoute.extend
  controllerName: 'apply_form'
  templateName: 'apply_form'
  title: ->
    'New application'

  model: (params) ->
    volunteer = @store.createRecord('volunteer')
    @store.createRecord('apply_form', volunteer: volunteer,fee: 2200)
