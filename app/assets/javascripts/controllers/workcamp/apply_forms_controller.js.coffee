Volant.WorkcampsApplyFormsController = Ember.ArrayController.extend


  page: 1
  query: null
  state: null
  tags: []

  queryParams: ['page','year','query','state','order','sortAscending']
  query_placeholder: "by name, birth number, email, bank account or keyword inside description"

  sortProperties: ['state','currentAssignment']

  sortFunction: (a,b) ->
    

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
