Volant.ListController = Ember.ArrayController.extend({

  needs: ['application','pagination']
  year: Ember.computed.alias('controllers.application.year')

  # automatic refresh on year selection
  year_observer: ( ->
    Ember.run.once(this,'send','yearChanged');
  ).observes('year')

  actions:
    set_page: (p) ->
      @set('page',p)
      @send 'search'
      false

})
