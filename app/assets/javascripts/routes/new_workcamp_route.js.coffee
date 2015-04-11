Volant.NewWorkcampRoute = Volant.WorkcampRoute.extend
  needs: ['account']
  viewName: 'workcamp'
  controllerName: 'workcamp'
  currentAccount: Ember.computed.alias('controllers.account.current')

  afterSave: (wc,opts) ->
    @flash_info 'Workcamp created.'
    if opts.redirect    
      @send 'goToWorkcamps'        
    else
      @transitionTo 'workcamp',wc
  
  model: (params,transition) ->
    id = $('meta[name="current-account-id"]').attr('content')
    @store.find('account',id).then (account) =>
      defaults = {
        language: 'English'
        minimal_age: 18
        maximal_age: 99
        places: 2
        places_for_males: 2
        places_for_females: 2
        publish_mode: 'SEASON'
        type: params.type
      }

      if params.type == 'incoming'
        defaults.organization = account.get('organization')
        defaults.country = account.get('organization.country')
        defaults.code = account.get('organization.code')

      # like Hash#merge in JS
      opts = $.extend(defaults,transition.queryParams)
      @store.createRecord('workcamp', opts)
