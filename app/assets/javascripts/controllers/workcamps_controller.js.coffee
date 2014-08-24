Volant.WorkcampsController = Volant.ListController.extend({

  query: ''

  sortProperties: ['name']
  sortAscending: true
  current_item: null

  do_search: ( ->
    @store.find('workcamp', { q: @get('query'), p: @get('current_page'), year: @get('current_year') }).then (wcs) =>
      @set('content',wcs)
   ).observes('current_year','current_page')

  actions:
    toggle_filter: ->
      console.info 'filtering'
      @toggleProperty('filter_is_visible')
      false

    adjust_page: (delta) ->
      delta = parseInt(delta)
      target = @get('current_page') + delta
      upper_bound = @get('pagination').total_pages

      if (target > 0) and (target <= upper_bound)
        @incrementProperty('current_page',delta)

    search_workcamp: ->
      @set('current_page',1)
      @do_search()
      false
})
