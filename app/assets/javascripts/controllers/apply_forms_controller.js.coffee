Volant.ApplyFormsController = Volant.ListController.extend({
  page: 1
  query: null
  sortProperties: 'created_at'
  sortAscending: true
  sortOptions: ['created_at','name']

  queryParams: ['page','year','query','sortProperties','sortAscending' ]

# {{view Ember.Select
#   contentBinding='sortOptions'
#   valueBinding='sortProperties'
#   optionValuePath="content"
#   optionLabelPath="content"
#   class="form-control"}}

  actions:
    search: ->
      @set 'page',1
      true


})
