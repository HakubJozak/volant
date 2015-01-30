Volant.ApplyFormsController = Volant.ListController.extend
  needs: ['tags']

  page: 1
  query: null
  state: null
  tags: []

  queryParams: ['page','year','query','state','order','sortAscending']
  query_placeholder: "Search by name, birth number, payment account or keyword..."

  order: 'createdAt'
  orderOptions: ['createdAt','name']
  sortProperties: ['createdAt']

  sortAscending: false
  sortAscendingOptions: [ {name:'Ascending', id: true },{ name:'Descending', id: false }]
  
  setSorting: (->
    props = switch @get('order')
      when 'createdAt' then ['createdAt']
      when 'name' then ['name']
    @set 'sortProperties',props
  ).observes('order','sortAscending')

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
