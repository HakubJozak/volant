Volant.ApplyFormsController = Volant.ListController.extend({
  page: 1
  queryParams: ['page','year','query' ]

  actions:
    search: ->
      @set 'page',1
      true
})
