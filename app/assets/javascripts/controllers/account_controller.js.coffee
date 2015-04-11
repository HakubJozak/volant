Volant.AccountController = Ember.ObjectController.extend
  needs: ['organizationsSelect']

  current: (->
    id = $('meta[name="current-account-id"]').attr('content')
    @store.find('account',id)
  ).property().volatile()

