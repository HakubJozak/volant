Volant.MiniSearchMixin = Ember.Mixin.create
  needs: ['application']
  query: null
  year: Ember.computed.alias('controllers.application.year')

  actions:
    reset: ->
      @set('query',null)
      @send('search')
      false

    search: ->
      name = @get('modelName')
      params = {q: @get('query'), year: @get('year')}
      @store.find(name,params).then (forms) =>
        @set('model',forms)
      false
