Volant.ApplyFormsController = Volant.ListController.extend
  targetModel: Volant.ApplyForm
  needs: ['tagsSelect']

  page: 1
  query: null
  state: null
  tags: []

  queryParams: ['page','year','query','state','order','sortAscending']
  query_placeholder: "by name, birth number, passport, email or phone"

  order: 'createdAt'
  orderOptions: [ {id: 'createdAt', name: 'Submitted'},{id:'name', name: 'Name'}]
  sortProperties: ['createdAt']

  csvDownloadUrl: (->
    year = @get('year')
    type = @get('mode')
    "/apply_forms.csv?year=#{year}&type=#{type}"
  ).property('year','mode')


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
