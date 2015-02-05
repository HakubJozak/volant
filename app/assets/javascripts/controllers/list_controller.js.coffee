Volant.ListController = Ember.ArrayController.extend({

  needs: ['application','pagination']
  year: Ember.computed.alias('controllers.application.year')

  sortAscending: false
  sortAscendingOptions: [ {name:'Ascending', id: true },{ name:'Descending', id: false }]

  # automatic refresh on year selection
  yearObserver: ( ->
    Ember.run.once(this,'send','yearChanged');
  ).observes('year')

  actions:
    set_page: (p) ->
      @set('page',p)
      @send 'search'
      false

})
