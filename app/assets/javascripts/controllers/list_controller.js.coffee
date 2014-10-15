Volant.ListController = Ember.ArrayController.extend(Volant.FlashControllerMixin, {

  # ---- year mixin ----

  needs: 'application'
  year: Ember.computed.alias('controllers.application.year')

  # automatic refresh on year selection
  yearChanged: ( ->
    Ember.run.once(this,'send','search');
  ).observes('year')

  # ---- pagination mixin ----

  filter_is_visible: true

  pagination: (->
    if @get('model.isLoaded')
      modelType = @get('model.type')
      @get('store').typeMapFor(modelType).metadata.pagination
  ).property('model.isLoaded')

  previous_page_exists: (->  @get('page') > 1).property('page')
  next_page_exists: (->  @get('page') < @get('pagination.total_pages')).property('pagination','page')

  actions:
    toggle_filter: ->
      console.info 'filtering'
      @toggleProperty('filter_is_visible')
      false

    set_page: (p) ->
      @set('page',p)
      @send 'refresh'
      false

    adjust_page: (delta) ->
      delta = parseInt(delta)
      target = @get('page') + delta
      upper_bound = @get('pagination').total_pages

      if (target > 0) and (target <= upper_bound)
        @incrementProperty('page',delta)
        @send 'refresh'

      false

})
