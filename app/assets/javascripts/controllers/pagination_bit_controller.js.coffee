Volant.PaginationBitController = Ember.ObjectController.extend({
  needs: [ 'pagination']
  current_page: Ember.computed.alias('controllers.pagination.model.current_page')

  active: (->
    @get('model').toString() == @get('current_page')
  ).property('model','current_page')

  link: (->
    @get('model') != '...'
  ).property('model')
})
