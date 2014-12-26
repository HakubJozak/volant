Volant.OrganizationsController = Volant.ListController.extend
  page: 1
  queryParams: ['page','query' ]
  needs: [ 'mini_workcamps' ]
  sortProperties: ['name']
