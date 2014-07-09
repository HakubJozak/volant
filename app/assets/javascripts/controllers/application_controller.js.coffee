Volant.ApplicationController = Ember.ArrayController.extend({
  query: ''

  actions:
    search_workcamp: ->
      @store.find('workcamp', { q: @get('query') }).then (wcs) =>
        @set('content',wcs)
})
