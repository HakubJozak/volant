Volant.ImportedWorkcampsController = Volant.ListController.extend
  sortProperties: ['createdAt']
  mode: Ember.computed.alias('controllers.application.mode')
  messages: []
  workcampRoute: 'imported_workcamp'

  page: 1
  queryParams: ['page']

  actions:
    # 'true' means it bubbles upwards
    import: -> @_clearMessages() ; true
    cancelAll: -> @_clearMessages() ; true
    confirmAll: -> @_clearMessages() ; true

  _clearMessages: ->
    @set 'messages', []
    true
