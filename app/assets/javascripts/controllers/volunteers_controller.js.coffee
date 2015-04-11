Volant.VolunteersController = Volant.ListController.extend
  query: null
  page: 1
  queryParams: ['query','page']
  query_placeholder: 'by name, birth number, email or phone number'

  actions:
    reset: ->
      @set 'query',''
      @set 'page',1
      @send 'search'
