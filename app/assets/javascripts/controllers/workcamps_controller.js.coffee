Volant.WorkcampsController = Ember.ArrayController.extend({
  query: ''
  current_page: 1
  sortProperties: ['name']
  sortAscending: true

  pagination: (->
    if @get('model.isLoaded')
      modelType = @get('model.type')
      @get('store').typeMapFor(modelType).metadata.pagination
  ).property('model.isLoaded')

  previous_page_exists: (->
    @get('current_page') > 1
  ).property('current_page')

  next_page_exists: (->
    @get('current_page') < @get('pagination.total_pages')
  ).property('pagination','current_page')

  do_search: ->
    @store.find('workcamp', { q: @get('query'), p: @get('current_page') }).then (wcs) =>
      @set('content',wcs)


  actions:
    adjust_page: (delta) ->
      delta = parseInt(delta)
      target = @get('current_page') + delta
      upper_bound = @get('pagination').total_pages

      if (target > 0) and (target <= upper_bound)
        @incrementProperty('current_page',delta)
        @do_search()

    search_workcamp: ->
      @set('current_page',1)
      @do_search()
      false
})
