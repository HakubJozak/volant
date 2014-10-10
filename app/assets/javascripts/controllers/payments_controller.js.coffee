Volant.PaymentsController = Volant.ListController.extend
  page: 1
  queryParams: ['page','year']

  actions:
    search: ->
      @set 'page',1
      true
