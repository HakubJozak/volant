Volant.WorkcampsController = Volant.ListController.extend({
  needs: ['countries','workcamp_intentions','organizations','tags']

  page: 1
  queryParams: ['query','page','year','from','to', 'min_duration','max_duration',
                'min_age','max_age', 'free', 'free_males', 'free_females']

  query_placeholder: "part of workcamp's name or code"

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

  isDirty: (->
    @get('model').any (wc) ->
      wc.get('isDirty')
  ).property('@each.isDirty')

  filter_visible: true
  editing_visible: false

  actions:
    toggle: (property) ->
      @set 'tag_ids', 'pepe'
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

})
