Volant.ImportVef = Volant.BaseRoute.extend

  model: (params) ->
    console.info 'sdfdsf'    
    id = $('meta[name="current-account-id"]').attr('content')
    @store.find('account',id)

  afterSave: (account,opts) ->
    @flash_info 'Settings saved.'
    @transitionTo 'index' if opts.redirect

  afterRollback: ->
    @transitionTo 'index'
