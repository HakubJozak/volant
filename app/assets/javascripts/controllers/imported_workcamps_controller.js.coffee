Volant.ImportedWorkcampsController = Volant.ListController.extend
  sortProperties: ['createdAt']
  mode: Ember.computed.alias('controllers.application.mode')
  messages: []

  page: 1
  queryParams: ['page']
  
  actions:
    import: -> @_clearMessages() ; true
    cancelAll: -> @_clearMessages() ; true
    confirmAll: -> @_clearMessages() ; true

  _clearMessages: ->
    @set 'messages', []
    true
          


    
