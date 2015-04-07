Volant.SearchApplyFormsController = Ember.ArrayController.extend Volant.MiniSearchMixin,
  needs: ['application']
  sortProperties: ['name']
  sortAscending: true

  query_placeholder: 'Name, Birthnumber, Email...'
  query: null
  year: Ember.computed.alias('controllers.application.year')
  mode: Ember.computed.alias('controllers.application.mode')

  actions:
    search: ->    
      params = {q: @get('query'), year: @get('year'), order: 'name' }
      @store.find('apply_form',params).then (list) =>
        @set 'model',list
      false  

    reset: ->
      @set('query',null)
      @send('search')
      false
