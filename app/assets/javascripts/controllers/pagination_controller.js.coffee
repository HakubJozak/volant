Volant.PaginationController = Ember.ObjectController.extend({
  first_page: Ember.computed.equal('current_page',1)

  previous_page: (->
    if @get('model.current_page') > 1
      @get('model.current_page') - 1
    else
      null
  ).property('model.current_page')

  next_page: (->
    if @get('model.current_page') < @get('model.total_pages')
      parseInt(@get('model.current_page') + 1)
    else
      null
  ).property('model.current_page')
})
