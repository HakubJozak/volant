Volant.MiniSearchMixin = Ember.Mixin.create
  needs: ['application']
  query: null
  year: Ember.computed.alias('controllers.application.year')
  mode: Ember.computed.alias('controllers.application.mode')

  actions:
    reset: ->
      @set('query',null)
      @send('search')
      false
