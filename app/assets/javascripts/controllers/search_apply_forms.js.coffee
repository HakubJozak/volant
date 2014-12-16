Volant.SearchApplyFormsController = Ember.ArrayController.extend({
  needs: ['application']
  query_placeholder: 'Name, Birthnumber, Email...'
  query: null
  year: Ember.computed.alias('controllers.application.year')

  actions:
    reset: ->
      @set('query',null)
      @send('search')
      false

    search: ->
      @store.find('apply_form',{q: @get('query'), year: @get('year')}).then (forms) =>
        @set('content',forms)
      false
})
