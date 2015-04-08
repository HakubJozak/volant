Volant.SearchWorkcampsController = Ember.ArrayController.extend Volant.MiniSearchMixin,
  sortProperties: ['name']
  sortAscending: true
  query_placeholder: 'Name or code'
  templateName: 'apply_form/search'

  actions:
    search: ->    
      params = {q: @get('query'), year: @get('year'), order: 'name' }
      @store.find('workcamp',params).then (list) =>
        @set 'model',list
      false  

    reset: ->
      @set('query',null)
      @send('search')
      false
  
  
