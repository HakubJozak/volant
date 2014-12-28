Volant.OrganizationsController = Volant.ListController.extend
  page: 1
  queryParams: ['page','query' ]
  needs: [ 'mini_workcamps' ]
  sortProperties: ['name']
  query: null

  actions:
    reset: ->
      @set('query',null)
      @send('search')
      false
