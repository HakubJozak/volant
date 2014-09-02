Volant.WorkcampsController = Volant.ListController.extend({

  queryParams: ['query','page','year']
  query: ''
  page: 1
  year: 'All'

  sortProperties: ['name']
  sortAscending: true
  current_item: null

  years: [ 'All',2015,2014,2013,2012,2011,2010]

  actions:
    search: ->
      @set 'page',1
      true

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
