Volant.WorkcampsController = Volant.ListController.extend
  needs: ['countries','workcamp_intentions','organizations','tags','starred_workcamps']

  page: 1
  queryParams: ['query','order','page','year','from','to',
                'min_duration','max_duration',
                'min_age','max_age', 'free',
                'free_males', 'free_females']

  query_placeholder: "part of workcamp's name or code"

  order: 'code'
  orderOptions: ['name','code','from','to','country']      
  
  query: ''
  from: null
  to: null
  min_duration: null
  max_duration: null
  min_age: null
  max_age: null
  free: null
  free_males: null
  free_females: null
  workcamp_intentions: []
  countries: []
  tags: []
  organizations: []

  sortProperties: ['name']
  sortAscending: true

  setSorting: (->
    props = switch @get('order')    
      when 'name' then ['name']
      when 'code' then ['code']
      when 'from' then ['from']
      when 'to' then ['to']
      when 'country' then ['country.name_en']      
    @set 'sortProperties',props
  ).observes('order')


  isDirty: (->
    @get('model').any (wc) ->
      wc.get('isDirty')
  ).property('@each.isDirty')

  filter_visible: true
  editing_visible: false

  actions:
    toggle: (property) ->
      @toggleProperty(property)
      false

    reset: ->
      # TODO: dry by getting the default values
      @set('query','')
      @set('page',1)
      @set('from',null)
      @set('to',null)
      @set('min_duration',null)
      @set('max_duration',null)
      @set('min_age',null)
      @set('max_age',null)
      @set('free',null)
      @set('free_males',null)
      @set('free_females',null)
      @set('tags',[])
      @set('workcamp_intentions',[])
      @set('countries',[])
      @set('organizations',[])
      @send('search')
