Volant.WorkcampsController = Volant.ListController.extend Volant.ToggleMixin,
  needs: ['countriesSelect','workcampIntentionsSelect','organizationsSelect','tagsSelect','starred_workcamps']

  page: 1
  queryParams: ['query','page','year','from','to',
                'min_duration','max_duration',
                'age', 'free',
                'free_males', 'free_females',
                'sortAscending','order']

  query_placeholder: "part of workcamp's name or code"

  csvDownloadUrl: (->
    year = @get('year')
    type = @get('mode')    
    "/workcamps.csv?year=#{year}&type=#{type}"
  ).property('year','mode')

  query: ''
  from: null
  to: null
  min_duration: null
  max_duration: null
  age: null
  free: null
  free_males: null
  free_females: null
  workcamp_intentions: []
  countries: []
  tags: []
  organizations: []

  sortProperties: ['name']
  sortAscending: true
  order: 'name'
  orderOptions: [{ id:'name', name:'Name'},{ id:'code', name:'Code'},
                 { id:'from', name:'From'},{ id:'to', name:'To'},
                 { id:'country', name:'Country'}]



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

  filter_visible: false
  editing_visible: false

  actions:
    filterOrganizationsByCountry: (country) ->
      if country
        id = country.get('id')
        filtered = @store.filter('organization',{ country_id: id },(org) => org.get('country.id') == id)
        @get('controllers.organizationsSelect').set('content', filtered)
      else
        all = @store.filter('organization',{ country_id: id},-> true)
        @get('controllers.organizationsSelect').set('content', all)
      false

    reset: ->
      # TODO: dry by getting the default values
      @set('query','')
      @set('page',1)
      @set('from',null)
      @set('to',null)
      @set('min_duration',null)
      @set('max_duration',null)
      @set('age',null)
      @set('free',null)
      @set('free_males',null)
      @set('free_females',null)
      @set('tags',[])
      @set('workcamp_intentions',[])
      @set('countries',[])
      @set('organizations',[])
      @send('search')
