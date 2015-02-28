Volant.OrganizationsController = Volant.ListController.extend
  page: 1
  queryParams: ['page','query' ]
  needs: [ 'mini_workcamps' ]
  sortProperties: ['country.code','name']
  sortAscending: true
  query: null

  actions:
    reset: ->
      @set('query',null)
      @send('search')
      false
