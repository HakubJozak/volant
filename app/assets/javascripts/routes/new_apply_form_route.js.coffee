Volant.NewApplyFormRoute = Volant.BaseRoute.extend Volant.ApplyFormActions,
  controllerName: 'apply_form'
  templateName: 'apply_form'
  title: ->
    'New application'

  model: (params,transition) ->
    defaults = {
      volunteer: @store.createRecord('volunteer')
      fee: 2200
      type: params.type
    }

    # like Hash#merge in JS
    opts = $.extend(defaults,transition.queryParams)    
    @store.createRecord('apply_form', opts)
