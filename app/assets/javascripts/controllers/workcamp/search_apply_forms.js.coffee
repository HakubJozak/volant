Volant.SearchApplyFormsController = Ember.ArrayController.extend Volant.MiniSearchMixin,
  needs: ['application']
  mode: Ember.computed.alias('controllers.application.mode')  

  sortProperties: ['name']
  sortAscending: true

  query_placeholder: 'Name, Birthnumber, Email...'
  query: null

  actions:
    search: ->    
      params = {q: @get('query'), year: @get('year'), order: 'name' }
      params.type = 'ltv' if @get('mode') == 'ltv'  
      @store.find('apply_form',params).then (list) =>
        @set 'model',list
      false  
