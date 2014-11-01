Volant.ApplyFormsController = Volant.ListController.extend({
  page: 1
  query: null
  sortProperties: ['created_at']
  sortAscending: false
  queryParams: ['page','year','query']

  actions:
    clear_query: ->
      @set('query',null)
      false

  page_reset: (->
    @set('page',1)
  ).observes('query')

# {{view Ember.Select
#   contentBinding='sortOptions'
#   valueBinding='sortProperties'
#   optionValuePath="content"
#   optionLabelPath="content"
#   class="form-control"}}


})
