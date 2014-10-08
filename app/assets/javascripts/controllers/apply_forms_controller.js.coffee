Volant.ApplyFormsController = Volant.ListController.extend({
  page: 1
  queryParams: ['page' ]

  do_search: ( ->
    @store.find('apply_form', { q: @get('query'), p: @get('current_page'), year: @get('current_year') }).then (result) =>
      @set('content',result)
   ).observes('current_year','current_page')

})
