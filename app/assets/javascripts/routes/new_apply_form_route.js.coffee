Volant.NewApplyFormRoute = Volant.ApplyFormRoute.extend Volant.ApplyFormActions,
  viewName: 'apply_form'
  controllerName: 'apply_form'

  title: ->
    'New application'

  afterSave: (form,opts) ->
    @flash_info 'Application created.'
    if opts.redirect
      @send 'goToApplyForms'
    else
      @transitionTo 'apply_form', form

  model: (params,transition) ->
    @store.createRecord('apply_form')
    @currentAccount().then (account) =>
      defaults = {
        fee: 2200
        type: params.type
      }

      if params.type != 'incoming'
        defaults.volunteer = @store.createRecord('volunteer')
        defaults.organization = account.get('organization')
        defaults.country = account.get('organization.country')

      # like Hash#merge in JS
      opts = $.extend(defaults,transition.queryParams)

      @store.createRecord('apply_form', opts)
