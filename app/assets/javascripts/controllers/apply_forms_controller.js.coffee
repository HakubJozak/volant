Volant.ApplyFormsController = Volant.ListController.extend({
  page: 1
  query: null
  state: null

  queryParams: ['page','year','query','state','order']
  query_placeholder: "Search by name, birth number, payment account or keyword..."

  order: 'createdAt'
  orderOptions: ['createdAt','name']
  sortProperties: ['createdAt']
  sortAscending: false
  
  setSorting: (->
    props = switch @get('order')
      when 'createdAt' then ['createdAt']
      when 'name' then ['name']
    @set 'sortProperties',props
  ).observes('order')

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
