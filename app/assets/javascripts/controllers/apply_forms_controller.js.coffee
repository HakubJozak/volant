Volant.ApplyFormsController = Volant.ListController.extend({
  page: 1
  query: null
  state: null
  sortProperties: ['created_at']
  sortAscending: false
  queryParams: ['page','year','query','state']
  query_placeholder: "Search by name, birth number, payment account or keyword..."
  actions:
    reset: ->
      @set('query',null)
      @send('search')
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
