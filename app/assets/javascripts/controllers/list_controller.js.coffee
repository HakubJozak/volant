Volant.ListController = Ember.ArrayController.extend(Volant.FlashControllerMixin, {

  # ---- year mixin ----

  needs: ['application','pagination']
  year: Ember.computed.alias('controllers.application.year')

  # automatic refresh on year selection
  yearChanged: ( ->
    Ember.run.once(this,'send','search');
  ).observes('year')

  filter_is_visible: true

  actions:
    toggle_filter: ->
      console.info 'filtering'
      @toggleProperty('filter_is_visible')
      false

    set_page: (p) ->
      @set('page',p)
      @send 'refresh'
      false

})
