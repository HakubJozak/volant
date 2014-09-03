Volant.WorkcampsController = Volant.ListController.extend({

  queryParams: ['query','page','year','from','to', 'min_duration','max_duration','min_age','max_age','my_year']
  query: ''
  page: 1
  from: null
  to: null
  min_duration: null
  max_duration: null
  min_age: null
  max_age: null

  sortProperties: ['name']
  sortAscending: true
  current_item: null

#  year: undefined
  years: [ 'All','2015','2014','2013','2012','2011','2010']
  my_year: 'All'



  actions:
    search: ->
      @set 'page',1
      true

  # automatic refresh on year selection
  yearChanged: ( ->
    Ember.run.once(this, 'send','search');
  ).observes('my_year')

  tags: (->
     @store.find('tag')).property()

  countries: (->
     @store.find('country')).property()

  workcamp_intentions: (->
     @store.find('workcamp_intention')).property()

  organizations: (->
     @store.find('organization')).property()
})
