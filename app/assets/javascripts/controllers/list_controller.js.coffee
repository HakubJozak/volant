Volant.ListController = Ember.ArrayController.extend(Volant.FlashControllerMixin, {

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

    adjust_page: (delta) ->
      delta = parseInt(delta)
      target = @get('page') + delta
      upper_bound = @get('pagination').total_pages

      if (target > 0) and (target <= upper_bound)
        @incrementProperty('page',delta)
        @send 'refresh'

})
