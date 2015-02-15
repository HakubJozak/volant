Volant.AccountRoute = Volant.BaseRoute.extend
  model: (params) ->
    id = $('meta[name="current-account-id"]').attr('content')
    @store.find('account',id)

  afterSave: ->
    @transitionTo 'index'
