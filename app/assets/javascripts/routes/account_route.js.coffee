Volant.AccountRoute = Volant.BaseRoute.extend
  toolbar: 'account/toolbar'

  model: (params) ->
    id = $('meta[name="current-account-id"]').attr('content')
    @store.find('account',id)

  afterSave: (account,opts) ->
    @flash_info 'Settings saved.'    
    @transitionTo 'index' if opts.redirect

  afterRollback: ->
    @transitionTo 'index'    
