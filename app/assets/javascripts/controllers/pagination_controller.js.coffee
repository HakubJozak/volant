Volant.PaginationController = Ember.ObjectController.extend
  just_one_page: Ember.computed.equal('total_pages',1)
  first_page: Ember.computed.equal('current_page',1)
  empty: Ember.computed.equal('total',0)
  perPage: Volant.settings.perPage

  previous_page: (->
    if @get('model.current_page') > 1
      @get('model.current_page') - 1
    else
      null
  ).property('model.current_page')

  next_page: (->
    if @get('model.current_page') < @get('model.total_pages')
      parseInt(@get('model.current_page')) + 1
    else
      null
  ).property('model.current_page')
