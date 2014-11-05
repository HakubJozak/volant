Volant.ListController = Ember.ArrayController.extend({

  # ---- year mixin ----

  needs: ['application','pagination']
  year: Ember.computed.alias('controllers.application.year')

  # automatic refresh on year selection
  yearChanged: ( ->
    Ember.run.once(this,'send','search');
  ).observes('year')

  actions:
    set_page: (p) ->
      @set('page',p)
      @send 'search'
      false

})
