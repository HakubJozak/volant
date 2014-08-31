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
    search_workcamp: ->
      @set('current_page',1)
      @do_search()
      false


  tags: (->
     @store.find('tag')).property()

  countries: (->
     @store.find('country')).property()

  workcamp_intentions: (->
     @store.find('workcamp_intention')).property()

  organizations: (->
     @store.find('organization')).property()






})
