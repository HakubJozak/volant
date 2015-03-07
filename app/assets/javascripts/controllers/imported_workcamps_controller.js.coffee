Volant.ImportedWorkcampsController = Ember.ArrayController.extend
  sortProperties: ['createdAt']
  needs: ['application','pagination']
  mode: Ember.computed.alias('controllers.application.mode')
  messages: []

  actions:
    import: -> @_clearMessages() ; true
    cancelAll: -> @_clearMessages() ; true
    confirmAll: -> @_clearMessages() ; true

  _clearMessages: ->
    @set 'messages', []
    true
          


    
