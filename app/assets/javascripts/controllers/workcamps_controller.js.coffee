Volant.WorkcampsController = Volant.ListController.extend({

  queryParams: ['query','page','year']
  query: ''
  page: 1
  year: 2014

  years: [ 'All years',2015,2014,2013,2012,2011,2010]

  sortProperties: ['name']
  sortAscending: true
  current_item: null

  yearChanged: ( ->
    Ember.run.once(this, 'send','refresh');
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
