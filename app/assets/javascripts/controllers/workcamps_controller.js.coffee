Volant.WorkcampsController = Ember.ArrayController.extend({
  query: ''
  current_page: 1
  sortProperties: ['name']
  sortAscending: true

  pagination: (->
    if @get('model.isLoaded')
      modelType = @get('model.type')
      @get('store').typeMapFor(modelType).metadata.pagination
  ).property('model.isLoaded','current_page')

  actions:
    go_to_page: (p) ->
      @set('current_page',p)
      @send('search_workcamp')

    search_workcamp: ->
      @store.find('workcamp', { q: @get('query'), p: @get('current_page') }).then (wcs) =>
        @set('content',wcs)
      false
})
