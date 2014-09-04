Volant.WorkcampsController = Volant.ListController.extend({

  queryParams: ['query','page','year','from','to', 'min_duration','max_duration','min_age','max_age', 'free', 'free_males', 'free_females']

  query: ''
  page: 1
  from: null
  to: null
  min_duration: null
  max_duration: null
  min_age: null
  max_age: null
  free: null
  free_males: null
  free_females: null

  sortProperties: ['name']
  sortAscending: true
  current_item: null

  years: [ 'All','2015','2014','2013','2012','2011','2010']
  year: 'All'

  actions:
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

    search: ->
      @set 'page',1
      true

  # automatic refresh on year selection
  yearChanged: ( ->
    Ember.run.once(this, 'send','search');
  ).observes('year')

  tags: (->
     @store.find('tag')).property()

  countries: (->
     @store.find('country')).property()

  workcamp_intentions: (->
     @store.find('workcamp_intention')).property()

  organizations: (->
     @store.find('organization')).property()
})
