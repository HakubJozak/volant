Volant.OrganizationsController = Volant.ListController.extend({
  page: 1
  queryParams: ['page' ]
  needs: [ 'mini_workcamps' ]
})
